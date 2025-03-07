# Load all saved ssh keys
# /usr/bin/ssh-add --apple-load-keychain ^/dev/null

# Fish syntax highlighting
set -g fish_color_autosuggestion 555 brblack
set -g fish_color_cancel -r
set -g fish_color_command --bold
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end brmagenta
set -g fish_color_error brred
set -g fish_color_escape bryellow --bold
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection brblue
set -g fish_color_search_match bryellow '--background=brblack'
set -g fish_color_selection white --bold '--background=brblack'
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline

# function fish_prompt
#     set_color brblack
#     echo -n "["(date "+%H:%M")"] "
#     set_color blue
#     if [ $PWD != $HOME ]
#         set_color brblack
#     	echo -n ':'
#     	set_color yellow
#     	echo -n (basename $PWD)
#     end
#     set_color green
#     printf '%s ' (__fish_git_prompt)
#     set_color red
#     echo -n '| '
#     set_color normal
# end

# Install Starship
/opt/homebrew/bin/starship init fish | source

# Rust configuration
set --export PATH $HOME/.cargo/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# uv
fish_add_path "~/.local/bin"
uv generate-shell-completion fish | source

# pnpm
set -gx PNPM_HOME /Users/alvarobartt/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# if status --is-interactive
#     set BASE16_SHELL "$HOME/.config/base16-shell/"
#     source "$BASE16_SHELL/profile_helper.fish"
# end

alias hf-ssh="kitten ssh -i ~/HuggingFace/alvaro-dev-us.pem"
alias hf-setup="~/hf-setup.sh"

alias give-me-tmux="~/give-me-tmux.sh"
alias gmt="~/give-me-tmux.sh"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/alvarobartt/.cache/lm-studio/bin

# zig language server
set -gx ZLS_HOME /Users/alvarobartt/zls
if not string match -q -- $ZLS_HOME $PATH
    set -gx PATH "$ZLS_HOME" $PATH
end

# activate default uv python env
source $HOME/.venv/bin/activate.fish
