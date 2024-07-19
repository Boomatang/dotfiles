set EDITOR /usr/bin/nvim
set FISH_USER_CLUSTER_CHECK 1

set DOTFILES $HOME/code/github.com/Boomatang/dotfiles
set DOT_SCRIPTS $DOTFILES/scripts

set -gx GRAB_PATH $HOME/source

set -gx GOPATH $HOME/go
set -gx GOSRC $GOPATH/src
set -gx GOROOT $HOME/sdk/go1.21.10
set -gx PATH $PATH $GOROOT/bin
set -gx PATH $PATH $GOPATH/bin /usr/local/go/bin
set -gx PATH $PATH $HOME/bin $HOME/.poetry/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.cargo/bin
set -gx PATH $PATH $HOME/.local/share/JetBrains/Toolbox/scripts

set KUBE_EDITOR nvim

pyenv init - | source

if status is-interactive
    alias k kubectl

    alias gs "git status"
    alias ga "git add"
    alias gc "git commit"
    alias gb "git branch"
    alias gbc "git checkout"
    alias gd "git difftool --no-symlinks --dir-diff"
    # Commands to run in interactive sessions can go here
end

