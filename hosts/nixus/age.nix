{ ... }:
{
  age = {
    secrets = {
      cadenPasswordHash.file = ./secrets/cadenPasswordHash.age;
      wireguardPrivate.file = ./secrets/wireguardPrivate.age;
      cadenGmail = {
        file = ./secrets/cadenGmailPassword.age;
        owner = "caden";
        group = "users";
      };
      paperlessPassword.file = ./secrets/paperlessPassword.age;
      porkbunKey.file = ./secrets/porkbunKey.age;
    };

    identityPaths = [
      "/root/.ssh/id_ed25519"
      "/etc/ssh/id_ed25519"
    ];
  };
}
