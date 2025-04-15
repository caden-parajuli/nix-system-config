let
  nixus = {
    # /etc/ssh/id_ed25519
    system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpTKdKg5QaITFexofZTzurx1NyUO7QKhT7i2CVE7Fxp root@flakinator";
    # /root/.ssh/id_ed25519
    root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICo9Sv25sRiULkeuKMFIBbYTfyrzeE8bHkb6hM349Mxv root@flakinator";
  };

  caden = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdnjLfDOYlRqAhV1Sc26fcTpqv/MNUP4PINT8Dr2bjW caden-parajuli@member.fsf.org";

  keys = [
    nixus.system
    nixus.root
    caden
  ];
in
{
  "cadenPasswordHash.age".publicKeys = keys;
  "cadenGmailPassword.age".publicKeys = keys;
}

