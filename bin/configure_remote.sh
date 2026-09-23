#!/usr/bin/env bash
# configure_remote.sh <ssh-host>
#
# Sets up a fresh pod. Installs packages, then for each target user installs
# rust (rustup) and uv, clones and installs dotfiles, copies git credentials,
# and writes the HF token (taken from the huggingface.co entry in
# .git-credentials) where huggingface_hub reads it.
#
# Target users: the ssh login, plus the uid-1000 user (ubuntu on stock
# images) when the login is root. RunPod drops you in as root and some
# tools refuse to run as root; in that case root's ssh keys are also
# mirrored to the uid-1000 user so you can log in as it directly. The
# user is never created here.
#
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

echo "==> $host: packages"
rssh bash -s <<'REMOTE'
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

sudo=""
[[ $EUID -ne 0 ]] && sudo=sudo

# build-essential: cargo needs a C linker to build most crates.
$sudo apt-get update -qq
$sudo apt-get install -y -qq --no-install-recommends \
  kakoune git git-lfs curl ca-certificates build-essential htop nvtop

# Mirror root's authorized_keys into the uid-1000 user's, appending only
# the keys it is missing. Skipped if nothing has uid 1000.
if [[ $EUID -eq 0 && -s /root/.ssh/authorized_keys ]]; then
  if entry=$(getent passwd 1000); then
    IFS=: read -r user _ _ _ _ home _ <<<"$entry"
    if [[ -n $home && -d $home ]]; then
      keys=$home/.ssh/authorized_keys
      mkdir -p "$home/.ssh"
      touch "$keys"
      # Only real key lines from root; skip any already present verbatim.
      grep -E '^[^#[:space:]]' /root/.ssh/authorized_keys \
        | grep -vxFf "$keys" >> "$keys" || true
      chmod 700 "$home/.ssh"
      chmod 600 "$keys"
      chown -R "$user:" "$home/.ssh"
      echo "copied root's ssh keys to $user (uid 1000)"
    else
      echo "warning: uid 1000 ($user) has no home dir, ssh keys not copied" >&2
    fi
  else
    echo "warning: no uid 1000 user, ssh keys not copied" >&2
  fi
fi
REMOTE

# Target users, one "<user>\t<home>" per line: the ssh login first, then the
# uid-1000 user when the login is root and that user has a home dir.
mapfile -t targets < <(rssh bash -s <<'PROBE'
printf '%s\t%s\n' "$(id -un)" "$HOME"
if [[ $EUID -eq 0 ]] && entry=$(getent passwd 1000); then
  IFS=: read -r u _ _ _ _ h _ <<<"$entry"
  [[ -d $h ]] && printf '%s\t%s\n' "$u" "$h"
fi
exit 0
PROBE
)
login_user=${targets[0]%%$'\t'*}

# rssh_as <user> <cmd...>: rssh, but running as <user>. Uses runuser for any
# user other than the login, which only happens when the login is root.
rssh_as() {
  local user=$1
  shift
  if [[ $user == "$login_user" ]]; then
    rssh "$@"
  else
    rssh runuser -u "$user" -- "$@"
  fi
}

# put <user> <abs-path> <mode>   (file contents on stdin)
# Contents travel base64-encoded as an argument so stdin is free for the
# remote script; parent dirs are created as <user> so they end up owned by it.
put() {
  local b64
  b64=$(base64 -w0)
  rssh_as "$1" bash -s -- "$2" "$3" "$b64" <<'EOF'
mkdir -p "$(dirname "$1")" && printf '%s' "$3" | base64 -d > "$1" && chmod "$2" "$1"
EOF
}

user_setup=$(cat <<'REMOTE'
set -euo pipefail
repo=$1

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
)

for t in "${targets[@]}"; do
  IFS=$'\t' read -r user home <<<"$t"
  echo "==> $host: toolchains + dotfiles ($user)"
  rssh_as "$user" bash -s -- "$DOTFILES_REPO" <<<"$user_setup"
done

if [[ ! -f $GIT_CREDENTIALS ]]; then
  echo "warning: $GIT_CREDENTIALS not found, skipping credentials" >&2
  echo "==> $host: done"
  exit 0
fi

# huggingface_hub does not read the git credential store; it reads
# $HF_TOKEN or $HF_HOME/token (default ~/.cache/huggingface/token).
hf_tok=$(grep -m1 'huggingface.co' "$GIT_CREDENTIALS" | sed -E 's#.*:(hf_[^@]+)@.*#\1#' || true)
[[ -n $hf_tok ]] || echo "warning: no huggingface.co entry in $GIT_CREDENTIALS, HF token not set" >&2

hf_home=""
if [[ -n $hf_tok ]]; then
  # Some RunPod images point HF_HOME at the volume; cover that too.
  # A login shell misses it: RunPod exports HF_HOME in /etc/rp_environment,
  # which .bashrc sources only after its non-interactive early return. Read
  # it from the container's own environment (pid 1) instead, then from the
  # RunPod file.
  probe='tr "\0" "\n" < /proc/1/environ 2>/dev/null | sed -n "s/^HF_HOME=//p" | head -1;'
  probe+=' [ -f /etc/rp_environment ] && . /etc/rp_environment 2>/dev/null && printf "%s\n" "${HF_HOME:-}"'
  hf_home=$(rssh "bash -c '$probe'" 2>/dev/null | grep -m1 . || true)
  hf_home=${hf_home%/}
  # The volume path is shared by all users, so write it once as the login
  # and leave it world-readable so the other target user can use it too.
  if [[ -n $hf_home ]]; then
    echo "==> $host: huggingface token ($hf_home)"
    printf '%s' "$hf_tok" | put "$login_user" "$hf_home/token" 644
  fi
fi

for t in "${targets[@]}"; do
  IFS=$'\t' read -r user home <<<"$t"
  echo "==> $host: git credentials ($user)"
  put "$user" "$home/.git-credentials" 600 < "$GIT_CREDENTIALS"
  [[ -n $hf_tok ]] || continue

  echo "==> $host: huggingface token ($user)"
  if [[ $hf_home != "$home/.cache/huggingface" ]]; then
    printf '%s' "$hf_tok" | put "$user" "$home/.cache/huggingface/token" 600
  fi

  # Verify against the path the container's processes will actually read,
  # so a bad token shows up now rather than at the first private download.
  # Run it through uvx (installed above) rather than the image's python,
  # which may not have huggingface_hub installed.
  hf_check_home=${hf_home:-$home/.cache/huggingface}
  rssh_as "$user" env "HF_HOME=$hf_check_home" "$home/.local/bin/uvx" -q --from huggingface_hub hf auth whoami \
    || echo "warning: HF token not usable by $user from $hf_check_home" >&2
done

echo "==> $host: done"
