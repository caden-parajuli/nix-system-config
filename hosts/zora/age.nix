{ ... }:
{
  age = {
    secrets = {
      cadenPasswordHash.file = ./secrets/cadenPasswordHash.age;
      wireguardPrivate.file = ./secrets/wireguardPrivate.age;
    };

    identityPaths = [
      "/root/.ssh/id_ed25519"
      "/etc/ssh/id_ed25519"
    ];
  };
}
