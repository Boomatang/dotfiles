#!/bin/bash

rm -rf ~/.config/fish
ln -sr $(pwd)/fish ~/.config/fish
echo "Please source the ~/.config/fish/config.fish or restart the instances"
