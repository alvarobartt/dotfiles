#!/usr/bin/env bash

set -euo pipefail

if (( EUID != 0 )); then
    echo "Run this script as root or with sudo." >&2
    exit 1
fi

if (( $# == 2 )) && [[ $2 != --key ]]; then
    [[ -f $2 ]] || { echo "Public key file not found: $2" >&2; exit 1; }
    public_key=$(head -n 1 "$2" | tr -d '\r')
elif (( $# == 3 )) && [[ $2 == --key ]]; then
    public_key=$3
else
    echo "Expected a username and a public key file, or a username and --key followed by a public key." >&2
    exit 1
fi

username=$1
if [[ ! $username =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    echo "Invalid username: $username" >&2
    exit 1
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
install -d -m 700 -o "$username" -g "$username" "$home_dir/.ssh"
touch "$home_dir/.ssh/authorized_keys"
chown "$username:$username" "$home_dir/.ssh/authorized_keys"
chmod 600 "$home_dir/.ssh/authorized_keys"
if ! grep -Fxq "$public_key" "$home_dir/.ssh/authorized_keys"; then
    printf '%s\n' "$public_key" >> "$home_dir/.ssh/authorized_keys"
fi
install -d -m 755 -o "$username" -g "$username" "$home_dir/workspace"

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

echo "Configured $username with SSH, Docker, and persistent /mnt access."
