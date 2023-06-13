set EDITOR /usr/bin/vim
set FISH_USER_CLUSTER_CHECK 1

set DOTFILES $HOME/code/github.com/Boomatang/dotfiles
set DOT_SCRIPTS $DOTFILES/scripts

set -gx GRAB_PATH $HOME/code

set -gx GOPATH $HOME/go
set -gx GOSRC $GOPATH/src
set -gx PATH $PATH /usr/bin/go/bin $GOPATH/bin /usr/local/go/bin
set -gx PATH $PATH $HOME/bin $HOME/.poetry/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH $HOME/.local/share/JetBrains/Toolbox/scripts

set KUBE_EDITOR vim

if status is-interactive
    alias k kubectl
    # Commands to run in interactive sessions can go here
end

