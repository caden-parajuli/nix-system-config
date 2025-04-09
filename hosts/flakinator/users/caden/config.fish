# Disable greeting
set fish_greeting

bind \cH backward-kill-path-component

# Add rust to path
fish_add_path ~/.cargo/bin

if command -q nix-your-shell
  nix-your-shell fish | source
end

set -gx DOTFILES ~/nix/hosts/flakinator/users/caden/dotfiles

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
  sudo nixos-rebuild switch --flake ~/nix
  stow-dots
end

function hyprlaunch
  exec uwsm start hyprland.desktop
end

if uwsm check may-start
   and uwsm select
  hyprlaunch
end

# Opam init
# source /home/caden/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
