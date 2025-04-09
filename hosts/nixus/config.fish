# Disable greeting
set fish_greeting
fish_config theme choose "Dracula"

bind \cH backward-kill-path-component

# Add rust to path
fish_add_path ~/.cargo/bin

if command -q nix-your-shell
  nix-your-shell fish | source
end

set -gx DOTFILES ~/nix/hosts/nixus/users/caden/dotfiles

function denv
  switch (count $argv)
  case 0
    nix flake init -t "github:caden-parajuli/devenvs"
    git add flake.nix
    direnv allow
  case 1
    nix flake init -t "github:caden-parajuli/devenvs#$argv[1]"
    git add flake.nix
    direnv allow
  case '*'
    echo "Too many arguments!"
  end
end

# Stow dotfiles
function stow-dots
  stow --dir=$DOTFILES --target=$HOME (path basename $DOTFILES/*)
end

# Rebuild NixOS
function nixrs
  sudo nixos-rebuild switch --flake ~/nix#nixus
  stow-dots
end

