set fish_greeting
bind \cH backward-kill-path-component
fish_add_path ~/.cargo/bin

if command -q nix-your-shell
  nix-your-shell fish | source
end

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

function nixrs
  sudo nixos-rebuild switch --flake ~/nix
end

# Opam init
source /home/caden/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

zoxide init fish | source
