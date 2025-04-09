{
  pkgs,
  ...
}:
{
  age = {
    secrets = {
    };

    identityPaths = [
      "/root/.ssh/id_ed25519"
      "/etc/ssh/id_ed25519"
    ];
  };
}
