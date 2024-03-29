#!/usr/bin/env bash

# git branch function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

git_project(){
  str=$(git config --get remote.origin.url)
  python $DOT_SCRIPTS/git_project.py $str $(parse_git_branch)
}

#PS1='\[\033[01;32m\][\[\033[00m\]\[\033[01;31m\]\A\[\033[01;31m\]\[\033[01;32m\] \u@\h\[\033[01;37m\] \W\[\033[01;31m\]$(parse_git_branch)\[\033[01;31m\]\[\033[01;32m\]]\[\033[00m\] \n\[\033[01;32m\]-->\[\033[01;37m\]\[\033[00m\] '
PS1='\[\033[01;32m\][\[\033[00m\]\[\033[01;31m\]\A\[\033[01;31m\]\[\033[01;32m\]] [\033[01;37m\]\W\[\033[01;31m\]$(git_project)\[\033[01;31m\]\[\033[01;32m\]]\[\033[00m\] \n\[\033[01;32m\]-->\[\033[01;37m\]\[\033[00m\] '

