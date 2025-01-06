# My NixOS System Configuration and Dotfiles

## Usage

To install on a NixOS system with fish, run:

```fish
git clone git@github.com:caden-parajuli/nix-system-config.git ~/nix
sudo nixos-rebuild switch --flake ~/nix
stow --dir=$HOME/nix/caden/dotfiles --target=$HOME (path basename ~/nix/caden/dotfiles/*)
```
