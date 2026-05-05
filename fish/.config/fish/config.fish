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
#         echo -n ':'
#         set_color yellow
#         echo -n (basename $PWD)
#     end
#     set_color green
#     printf '%s ' (__fish_git_prompt)
#     set_color red
#     echo -n '| '
#     set_color normal
# end

fish_add_path /opt/homebrew/bin

if status --is-interactive; and command -q starship
    # Install Starship
    starship init fish | source
end

# Rust configuration
fish_add_path $HOME/.cargo/bin
set -gx CARGO_TARGET_DIR $HOME/.cargo-target

# bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# uv
fish_add_path "$HOME/.local/bin"
if status --is-interactive; and command -q uv
    uv generate-shell-completion fish | source
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME
# pnpm end

# if status --is-interactive
#     set BASE16_SHELL "$HOME/.config/base16-shell/"
#     source "$BASE16_SHELL/profile_helper.fish"
# end

# zig language server
set -gx ZLS_HOME "$HOME/zls"
fish_add_path $ZLS_HOME

# activate default uv python env
if test -f "$HOME/.venv/bin/activate.fish"
    source "$HOME/.venv/bin/activate.fish"
end
