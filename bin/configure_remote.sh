#!/usr/bin/env bash
# configure_remote.sh <ssh-host>
#
# Sets up a fresh pod: installs kakoune, rust (rustup) and uv, clones
# and installs dotfiles,
# copies git credentials, and writes the HF token (taken from the
# huggingface.co entry in .git-credentials) where huggingface_hub reads it.
# Safe to re-run.
#
# Overridable via environment:
#   DOTFILES_REPO    (default: https://github.com/pimpale/dotfiles)
#   GIT_CREDENTIALS  (default: ~/.git-credentials)

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <ssh-host>" >&2
  exit 1
fi
host=$1

DOTFILES_REPO=${DOTFILES_REPO:-https://github.com/pimpale/dotfiles}
GIT_CREDENTIALS=${GIT_CREDENTIALS:-$HOME/.git-credentials}

# One SSH connection, reused for every command below.
ctl_dir=$(mktemp -d)
ssh_opts=(-o ControlMaster=auto -o "ControlPath=$ctl_dir/%C" -o ControlPersist=60)
cleanup() {
  ssh "${ssh_opts[@]}" -O exit "$host" 2>/dev/null || true
  rm -rf "$ctl_dir"
}
trap cleanup EXIT

rssh() { ssh "${ssh_opts[@]}" "$host" "$@"; }

# put <remote-path-relative-to-home> <mode>   (file contents on stdin)
put() {
  rssh "mkdir -p \"\$(dirname '$1')\" && cat > '$1' && chmod $2 '$1'"
}

echo "==> $host: packages + dotfiles"
rssh bash -s -- "$DOTFILES_REPO" <<'REMOTE'
set -euo pipefail
repo=$1
export DEBIAN_FRONTEND=noninteractive

sudo=""
[[ $EUID -ne 0 ]] && sudo=sudo

# build-essential: cargo needs a C linker to build most crates.
if ! command -v kak >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1 \
   || ! command -v cc >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1 \
   || ! command -v nvtop >/dev/null 2>&1; then
  $sudo apt-get update -qq
  $sudo apt-get install -y -qq --no-install-recommends \
    kakoune git git-lfs curl ca-certificates build-essential nvtop
fi

# Rust toolchain -> ~/.cargo/bin. The installer adds ~/.cargo/bin to
# ~/.profile and ~/.bashrc; config.fish already has it on PATH.
if [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal
fi

# uv -> ~/.local/bin (also already on PATH in config.fish).
if [[ ! -x "$HOME/.local/bin/uv" ]]; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [[ -d "$HOME/dotfiles/.git" ]]; then
  git -C "$HOME/dotfiles" pull -q --ff-only
else
  git clone -q "$repo" "$HOME/dotfiles"
fi
sh "$HOME/dotfiles/install.sh" 2>/dev/null
REMOTE

if [[ ! -f $GIT_CREDENTIALS ]]; then
  echo "warning: $GIT_CREDENTIALS not found, skipping credentials" >&2
  echo "==> $host: done"
  exit 0
fi

echo "==> $host: git credentials"
put .git-credentials 600 < "$GIT_CREDENTIALS"

# huggingface_hub does not read the git credential store; it reads
# $HF_TOKEN or $HF_HOME/token (default ~/.cache/huggingface/token).
hf_tok=$(grep -m1 'huggingface.co' "$GIT_CREDENTIALS" | sed -E 's#.*:(hf_[^@]+)@.*#\1#' || true)
if [[ -n $hf_tok ]]; then
  echo "==> $host: huggingface token"
  printf '%s' "$hf_tok" | put .cache/huggingface/token 600
  # Some RunPod images point HF_HOME at the volume; cover that too.
  # A login shell misses it: RunPod exports HF_HOME in /etc/rp_environment,
  # which .bashrc sources only after its non-interactive early return. Read
  # it from the container's own environment (pid 1) instead, then from the
  # RunPod file.
  probe='tr "\0" "\n" < /proc/1/environ 2>/dev/null | sed -n "s/^HF_HOME=//p" | head -1;'
  probe+=' [ -f /etc/rp_environment ] && . /etc/rp_environment 2>/dev/null && printf "%s\n" "${HF_HOME:-}"'
  hf_home=$(rssh "bash -c '$probe'" 2>/dev/null | grep -m1 . || true)
  hf_home=${hf_home%/}
  if [[ -n $hf_home && $hf_home != "$HOME/.cache/huggingface" ]]; then
    printf '%s' "$hf_tok" | rssh "mkdir -p '$hf_home' && cat > '$hf_home/token' && chmod 600 '$hf_home/token'"
  fi

  # Verify against the path the container's processes will actually read,
  # so a bad token shows up now rather than at the first private download.
  hf_check_home=${hf_home:-\$HOME/.cache/huggingface}
  rssh "HF_HOME=\"$hf_check_home\" python3 -c 'from huggingface_hub import whoami; print(\"hf user:\", whoami()[\"name\"])'" \
    || echo "warning: HF token not usable from $hf_check_home" >&2
else
  echo "warning: no huggingface.co entry in $GIT_CREDENTIALS, HF token not set" >&2
fi

echo "==> $host: done"
