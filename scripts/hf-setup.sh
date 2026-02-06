#!/bin/bash

set -euxo pipefail

# Default user and SSH key
DEFAULT_USER="ubuntu"
DEFAULT_SSH_KEY="~/HuggingFace/alvaro-dev-us.pem"

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <USER>@<IP> [SSH_KEY_PATH]"
    exit 1
fi

# Parse the user and IP from the first argument
USER_IP=$1
USER=${USER_IP%@*}
IP=${USER_IP#*@}

# Use default user if not specified
if [ "$USER" == "$IP" ]; then
    USER=$DEFAULT_USER
fi

# SSH key path (use default if not provided)
SSH_KEY_PATH=${2:-$DEFAULT_SSH_KEY}

# Function to add host key to known_hosts
add_to_known_hosts() {
    local ip=$1
    ssh-keyscan -H $ip >>~/.ssh/known_hosts 3>/dev/null
    if [ $? -eq 0 ]; then
        echo "Host key for $ip added to known_hosts"
    else
        echo "Failed to add host key for $ip"
    fi
}

# Function to run scp and ssh commands
run_remote() {
    # Add host key to known_hosts
    add_to_known_hosts $IP

    local ssh_cmd="ssh -i $SSH_KEY_PATH"
    local scp_cmd="scp -i $SSH_KEY_PATH"

    # Create the `.ssh` directory and assign permissions
    $ssh_cmd "$USER@$IP" "/usr/bin/mkdir -p ~/.config/nvim ~/.ssh"
    $ssh_cmd "$USER@$IP" "chmod 700 ~/.ssh"

    # Create necessary directories on remote machine and copy files (overwrite existing ones)
    $scp_cmd ~/.config/nvim/init.lua "$USER@$IP:~/.config/nvim/init.lua"
    $scp_cmd ~/.config/nvim/lazy-lock.json "$USER@$IP:~/.config/nvim/lazy-lock.json"
    $scp_cmd ~/.ssh/id_ed25519 "$USER@$IP:~/.ssh/id_ed25519"
    $scp_cmd ~/.ssh/id_ed25519.pub "$USER@$IP:~/.ssh/id_ed25519.pub"
    $scp_cmd ~/.tmux.conf "$USER@$IP:~/.tmux.conf"

    # Also add the GPG key used to sign commits on the Hugging Face Hub
    # TODO(gpg): Temporarily remove until fully fixed
    $scp_cmd ~/hf-sign-priv.asc "$USER@$IP:~/hf-sign-priv.asc"

    # Copy Kitty terminfo to remote
    # https://sw.kovidgoyal.net/kitty/kittens/ssh/#copying-terminfo-files-manually
    infocmp -x xterm-kitty 2>/dev/null | $ssh_cmd "$USER@$IP" 'tic -x - 2>/dev/null' || true
    # Copy Ghostty terminfo to remote
    # https://ghostty.org/docs/help/terminfo#copy-ghostty's-terminfo-to-a-remote-machine
    infocmp -x xterm-ghostty 2>/dev/null | $ssh_cmd "$USER@$IP" 'tic -x - 2>/dev/null' || true

    # Run the setup script with an updated PATH
    $ssh_cmd "$USER@$IP" 'PATH=\$PATH:/usr/bin:/bin:/usr/local/bin bash -s' <<EOF
# Source .bashrc and .profile if they exist
[ -f ~/.bashrc ] && source ~/.bashrc
[ -f ~/.profile ] && source ~/.profile

# Now run the actual setup script
$1
EOF
}

# Remote setup script
REMOTE_SCRIPT=$(
    cat <<'EOFSCRIPT'
#!/bin/bash

# Ensure .bashrc is sourced on login shells
if ! grep -qxF 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' ~/.bash_profile 2>/dev/null; then
    echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> ~/.bash_profile
fi

if ! grep -qxF 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' ~/.profile 2>/dev/null; then
    echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> ~/.profile
fi

# Create .ssh/config only if it doesn't exist
if [ ! -f ~/.ssh/config ]; then
    cat << 'EOF' > ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519

Host hf.co
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOF
fi

# Configure SSH agent persistence if not already present
if ! grep -q "ssh-add ~/.ssh/id_ed25519" ~/.bash_profile; then
    cat << 'EOF' >> ~/.bash_profile

# SSH Agent management (only for interactive logins)
if [ -n "$SSH_CONNECTION" ] && [ -z "$SSH_AGENT_PID" ]; then
    eval "$(ssh-agent -s -t 86400)" >/dev/null  # 24h timeout
    ssh-add ~/.ssh/id_ed25519
fi
EOF
fi

# Set correct permissions for SSH keys
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config

# TODO(gpg): Temporarily remove until fully fixed
# # Set correct permissions for GPG key
# chmod 600 ~/hf-sign-priv.asc
# gpg --import ~/hf-sign-priv.asc

# Function to check and install packages
install_package() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        echo "Installing $1..."
        sudo apt-get update && sudo apt-get install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Also install git-lfs required when working with Hugging Face Hub repositories
install_package git-lfs

# Finally, install `build-essential` to install the `gcc` toolchain required for
# `rustc` if not installed already
install_package build-essential
# And `libssl-dev` and `pkg-config` as required by OpenSSL
install_package libssl-dev
install_package pkg-config

# Optionally, also install `protobuf-compiler` which is a dependency I require
# somewhat frequently when working with gRPC
install_package protobuf-compiler

# Also install `cmake` which is required for building some packages from source
install_package cmake

# Remove pyenv if it exists
if [ -d "$HOME/.pyenv" ]; then
    echo "Removing pyenv..."
    rm -rf $(pyenv root)
    sed -i '/pyenv/d' ~/.bashrc ~/.profile ~/.zshrc 2>/dev/null || true
fi

# Install uv using its installer via curl if not already installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.local/bin/env
fi

grep -qxF 'source $HOME/.local/bin/env' ~/.bashrc || echo 'source $HOME/.local/bin/env' >> ~/.bashrc
grep -qxF 'export PATH=/usr/local/bin:$PATH' ~/.bashrc || echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc

# Install Python 3.12 with uv and set it as default
echo "Installing Python 3.12 with uv..."
uv python install 3.12
uv python pin 3.12

# Create a virtual environment in the home directory using Python 3.12 with uv
VIRTUAL_ENV="$HOME/.venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment with Python 3.12..."
    uv venv $HOME/.venv --python 3.12
    source $HOME/.venv/bin/activate
else
    echo "Virtual environment already exists."
fi

# Activate virtual environment by default in shell configuration files
grep -qxF 'source $HOME/.venv/bin/activate' ~/.bashrc || echo 'source $HOME/.venv/bin/activate' >> ~/.bashrc

# Install ruff and pyright in the virtual environment using uv tool install
echo "Installing ruff and pyright..."
uv tool install ruff
uv pip install pyright

# Install Rust if not already installed, along with rust-analyzer via rustup
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

grep -qxF 'source $HOME/.cargo/env' ~/.bashrc || echo 'source $HOME/.cargo/env' >> ~/.bashrc

echo "Installing rust-analyzer..."
rustup component add rust-analyzer
echo "Installing sd (sed replacement)"
cargo install sd

# NOTE: both `rg` and `fd` are required by `telescope.nvim`
# NOTE: `rg` is required within this build script to grab the latest version of
# both `nvim` and `lazygit` from GitHub Releases, and `--features pcre2` is to
# be able to use `rg -Po ...`
echo "Installing rg (grep replacement)"
cargo install ripgrep --features pcre2
echo "Installing fd (find replacement)"
cargo install fd-find
echo "Installing cargo-insta (snapshot testing)"
cargo install cargo-insta

# NOTE: not included by default, but I use it quite often so here in case I change
# my mind and want to add it within my defaults
# echo "Installing viu (terminal image viewer)"
# cargo install viu

# Install Node.js and npm (required for some LazyVim plugins)
if ! command -v node &> /dev/null; then
    echo "Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install or update Neovim
INSTALL_NVIM=false
if ! command -v nvim &> /dev/null; then
    echo "Neovim not found. Installing latest version..."
    INSTALL_NVIM=true
else
    CURRENT_NVIM_VERSION=$(nvim --version | head -n1 | rg -Po 'v\K[0-9]+\.[0-9]+\.[0-9]+')
    LATEST_NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | rg -Po '"tag_name": "v\K[^"]*')
    if [ "$CURRENT_NVIM_VERSION" != "$LATEST_NVIM_VERSION" ]; then
        echo "Neovim version $CURRENT_NVIM_VERSION found. Latest is $LATEST_NVIM_VERSION. Updating..."
        INSTALL_NVIM=true
    else
        echo "Neovim is up to date (version $CURRENT_NVIM_VERSION)."
    fi
fi

if [ "$INSTALL_NVIM" = true ]; then
    LATEST_NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | rg -Po '"tag_name": "v\K[^"]*')
    sudo apt remove neovim -y || true
    sudo rm -rf $HOME/neovim || true
    sudo rm -rf $VIMRUNTIME || true
    git clone https://github.com/neovim/neovim $HOME/neovim
    cd $HOME/neovim && git checkout "v$LATEST_NVIM_VERSION" && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install
    sudo rm -rf $HOME/neovim
fi

# Install or update LazyGit
INSTALL_LAZYGIT=false
if ! command -v lazygit &> /dev/null; then
    echo "LazyGit not found. Installing latest version..."
    INSTALL_LAZYGIT=true
else
    CURRENT_LAZYGIT_VERSION=$(lazygit --version | rg -Po ', version=\K[0-9]+\.[0-9]+\.[0-9]+')
    LATEST_LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | rg -Po '"tag_name": "v\K[^"]*')
    if [ "$CURRENT_LAZYGIT_VERSION" != "$LATEST_LAZYGIT_VERSION" ]; then
        echo "LazyGit version $CURRENT_LAZYGIT_VERSION found. Latest is $LATEST_LAZYGIT_VERSION. Updating..."
        INSTALL_LAZYGIT=true
    else
        echo "LazyGit is up to date (version $CURRENT_LAZYGIT_VERSION)."
    fi
fi

if [ "$INSTALL_LAZYGIT" = true ]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | rg -Po '"tag_name": "v\K[^"]*')

    echo "Downloading LazyGit v${LAZYGIT_VERSION}..."
    if curl --retry 5 --retry-delay 3 --max-time 120 -fSLo lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; then
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm -f lazygit lazygit.tar.gz
        echo "LazyGit installed successfully."
    else
        echo "Warning: Failed to download LazyGit. Skipping LazyGit installation."
        rm -f lazygit.tar.gz
    fi
fi

# Install LazyVim plugins
echo "Installing LazyVim plugins..."
nvim --headless '+Lazy install' '+MasonInstallAll' '+qall' >/dev/null 2>&1

# Set up Git configuration
git config --global init.defaultbranch main
git config --global pull.rebase false
git config --global user.email "36760800+alvarobartt@users.noreply.github.com"
git config --global user.name "Alvaro Bartolome"
# NOTE: for Hugging Face repositories the SSH key cannot be used to sign the
# commits, so we need to rely on `hf-repo.sh` to set the signing up with GPG, and
# also to update the email.
git config --global user.signingkey "~/.ssh/id_ed25519.pub"
git config --global gpg.format ssh
git config --global commit.gpgsign true

echo "Setup complete!"
EOFSCRIPT
)

# Run the remote commands
run_remote "$REMOTE_SCRIPT"

echo "🎉 hf-ssh $USER@$IP"
