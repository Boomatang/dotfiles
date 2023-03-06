if status is-interactive
    set EDITOR /usr/bin/vim
    set FISH_USER_CLUSTER_CHECK 1
    
    set DOTFILES $HOME/code/github.com/Boomatang/dotfiles
    set DOT_SCRIPTS $DOTFILES/scripts

    set GOPATH $HOME/go
    set GOSRC $GOPATH/src
    set PATH $PATH /usr/bin/go/bin $GOPATH/bin
    set PATH $PATH $HOME/bin $HOME/.poetry/bin
    set PATH $PATH $HOME/.local/bin

    set KUBE_EDITOR vim

    alias k kubectl
    # Commands to run in interactive sessions can go here
end

