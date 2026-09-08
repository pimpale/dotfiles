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
   || ! command -v cc >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  $sudo apt-get update -qq
  $sudo apt-get install -y -qq --no-install-recommends \
    kakoune git git-lfs curl ca-certificates build-essential
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
  # Login shell so the pod's env (incl. HF_HOME) is loaded.
  hf_home=$(rssh 'bash -lc "printf %s \"\${HF_HOME:-}\"" 2>/dev/null' || true)
  if [[ -n $hf_home && $hf_home != "$HOME/.cache/huggingface" ]]; then
    printf '%s' "$hf_tok" | rssh "mkdir -p '$hf_home' && cat > '$hf_home/token' && chmod 600 '$hf_home/token'"
  fi
else
  echo "warning: no huggingface.co entry in $GIT_CREDENTIALS, HF token not set" >&2
fi

echo "==> $host: done"
