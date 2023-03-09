if status is-interactive
    set EDITOR /usr/bin/vim
    set FISH_USER_CLUSTER_CHECK 1
    
    set DOTFILES $HOME/code/github.com/Boomatang/dotfiles
    set DOT_SCRIPTS $DOTFILES/scripts

    set -x GRAB_PATH $HOME/code

    set -x GOPATH $HOME/go
    set -x GOSRC $GOPATH/src
    set -x PATH $PATH /usr/bin/go/bin $GOPATH/bin /usr/local/go/bin
    set -x PATH $PATH $HOME/bin $HOME/.poetry/bin
    set -x PATH $PATH $HOME/.local/bin

    set KUBE_EDITOR vim

    alias k kubectl
    # Commands to run in interactive sessions can go here
end

