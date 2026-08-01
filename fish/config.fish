if status is-interactive
# Commands to run in interactive sessions can go here
end

# Get rid of the welcome message
set fish_greeting ""

# Setup brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Stop underlining valid paths
set fish_color_valid_path

# Alias'
alias vim="nvim"
alias nv="neovide"

# Path additions
set -U fish_user_paths "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $fish_user_paths
set -U fish_user_paths /opt/nvim/bin $fish_user_paths
set -U fish_user_paths /opt/local/bin $fish_user_paths #macports
set -U fish_user_paths  ~/go/bin $fish_user_paths
set -U fish_user_paths  "/Applications/Sublime Text.app/Contents/SharedSupport/bin" $fish_user_paths
