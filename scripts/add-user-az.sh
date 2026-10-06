#!/usr/bin/env bash

set -euo pipefail

if (( EUID != 0 )); then
    echo "Run this script as root or with sudo." >&2
    exit 1
fi

username=${1:-}
if [[ ! $username =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    echo "Invalid username: $username" >&2
    exit 1
fi
shift

sudo_access=false
public_key_file=
public_key=
while (( $# )); do
    case $1 in
        --sudo-access)
            sudo_access=true
            shift
            ;;
        --key)
            if (( $# < 2 )) || [[ -n $public_key || -n $public_key_file ]]; then
                echo "Expected one public key after --key." >&2
                exit 1
            fi
            public_key=$2
            shift 2
            ;;
        --*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            if [[ -n $public_key || -n $public_key_file ]]; then
                echo "Provide one public key file or one --key value." >&2
                exit 1
            fi
            public_key_file=$1
            shift
            ;;
    esac
done

if [[ -n $public_key_file ]]; then
    [[ -f $public_key_file ]] || { echo "Public key file not found: $public_key_file" >&2; exit 1; }
    public_key=$(head -n 1 "$public_key_file" | tr -d '\r')
fi
if [[ ! $public_key =~ ^(ssh-ed25519|ssh-rsa|ecdsa-sha2-[^[:space:]]+)[[:space:]]+[^[:space:]]+ ]]; then
    echo "Invalid OpenSSH public key." >&2
    exit 1
fi

if ! id "$username" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$username"
fi
passwd -l "$username"

home_dir=$(getent passwd "$username" | cut -d: -f6)
[[ -n $home_dir ]] || { echo "Could not find home directory for $username" >&2; exit 1; }
primary_group=$(id -gn "$username")
if [[ ! -d $home_dir ]]; then
    install -d -m 755 -o "$username" -g "$primary_group" "$home_dir"
fi
install -d -m 700 -o "$username" -g "$primary_group" "$home_dir/.ssh"
touch "$home_dir/.ssh/authorized_keys"
chown "$username:$primary_group" "$home_dir/.ssh/authorized_keys"
chmod 600 "$home_dir/.ssh/authorized_keys"
if ! grep -Fxq "$public_key" "$home_dir/.ssh/authorized_keys"; then
    printf '%s\n' "$public_key" >> "$home_dir/.ssh/authorized_keys"
fi
if [[ ! -d $home_dir/workspace ]]; then
    install -d -m 755 -o "$username" -g "$primary_group" "$home_dir/workspace"
fi

# Repair files left behind by prior root-run setup commands, including uv's
# cache and virtual environments. Do not follow symlinks inside the home.
chown -RH -- "$username:$primary_group" "$home_dir"

if ! runuser -u "$username" -- env HOME="$home_dir" PATH="$home_dir/.local/bin:/usr/local/bin:/usr/bin:/bin" sh -c 'command -v uv >/dev/null 2>&1'; then
    installer=$(mktemp)
    trap 'rm -f "$installer"' EXIT
    curl -fsSL https://astral.sh/uv/install.sh -o "$installer"
    chmod 644 "$installer"
    runuser -u "$username" -- env HOME="$home_dir" UV_INSTALL_DIR="$home_dir/.local/bin" UV_NO_MODIFY_PATH=1 sh "$installer"
    rm -f "$installer"
    trap - EXIT
fi
runuser -u "$username" -- env HOME="$home_dir" PATH="$home_dir/.local/bin:/usr/local/bin:/usr/bin:/bin" uv --version >/dev/null

cat > /etc/profile.d/add-user-az-uv.sh <<'PROFILE'
if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) PATH="$HOME/.local/bin:$PATH"; export PATH ;;
    esac
fi
PROFILE
chmod 644 /etc/profile.d/add-user-az-uv.sh

if [[ $sudo_access == true ]]; then
    getent group sudo >/dev/null || groupadd sudo
    usermod -aG sudo "$username"
    sudoers_file=$(mktemp)
    trap 'rm -f "$sudoers_file"' EXIT
    printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$username" > "$sudoers_file"
    chmod 440 "$sudoers_file"
    visudo -cf "$sudoers_file"
    install -m 440 -o root -g root "$sudoers_file" "/etc/sudoers.d/90-add-user-az-$username"
    rm -f "$sudoers_file"
    trap - EXIT
fi

getent group docker >/dev/null || groupadd docker
getent group mntusers >/dev/null || groupadd mntusers
usermod -aG docker,mntusers "$username"

# The Azure data disk can be mounted after boot. Apply permissions to the
# mounted filesystem, rather than to the underlying /mnt directory.
cat > /etc/systemd/system/add-user-az-mnt.service <<'UNIT'
[Unit]
Description=Grant mntusers access to the Azure /mnt mount

[Service]
Type=oneshot
TimeoutStartSec=0
ExecStart=/bin/bash -c 'until mountpoint -q /mnt; do sleep 2; done; chgrp mntusers /mnt; chmod 2775 /mnt'

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable add-user-az-mnt.service
systemctl start --no-block add-user-az-mnt.service

if mountpoint -q /mnt; then
    chgrp mntusers /mnt
    chmod 2775 /mnt
fi

echo "Configured $username with SSH, uv, Docker, and persistent /mnt access."
