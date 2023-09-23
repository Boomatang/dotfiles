#!/usr/bin/env bash

colo default

filetype plugin indent on
syntax on

set showmode


set autoindent
set tabstop=2
set shiftwidth=2
set expandtab


set number
set relativenumber

" These work as expected when you are not on the last line of the page "
map #2 :set number <enter> :set relativenumber <enter>
map #3 :set nonumber <enter> :set norelativenumber <enter>
