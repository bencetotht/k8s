#!/bin/bash

DATE=$(date +%Y-%m-%d)

# Backing up vscode settings and keybindings
cp "~/Library/Application\ Support/Code/User/settings.json" "./${DATE}-vsc-settings.json"
cp "~/Library/Application\ Support/Code/User/keybindings.json" "./${DATE}-vsc-keybindings.json"

# creatimg brew bundle
brew bundle dump --file="./${DATE}-brew-bundle.txt"

# creating a list of installed apps
mdfind "kMDItemKind == 'Application'" > "./${DATE}-installed-apps.txt"

# copy .zshrc
cp ~/.zshrc "./${DATE}-zshrc.zsh"

# copy .zprofile
cp ~/.zprofile "./${DATE}-zprofile.zsh"

# backing up kubernetes config
cp ~/.kube/config "./${DATE}-kube-config.yaml"

# backing up docker config
cp ~/.docker/config.json "./${DATE}-docker-config.json"

# backing up system hosts file
cp /etc/hosts "./${DATE}-hosts"

