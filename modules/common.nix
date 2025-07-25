{ pkgs, inputs, config, lib, ...}:
{
    environment.systemPackages = with pkgs; [
      vim
      curl
      helix
    ];

    users.users.cbarlow = {
      uid = 501;
      extraGroups = [ "wheel" "orbstack" ];

      # simulate isNormalUser, but with an arbitrary UID
      isSystemUser = true;
      group = "users";
      createHome = true;
      home = "/home/cbarlow";
      homeMode = "700";
      useDefaultShell = true;
    };

    # This being `true` leads to a few nasty bugs, change at your own risk!
    users.mutableUsers = false;

    security.sudo.execWheelOnly = true;
    security.sudo.wheelNeedsPassword = false;

    programs = {
      command-not-found.enable = false;
      nix-ld.enable = true;
      fish.enable = true;
    };

    users.defaultUserShell = pkgs.fish;

    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      registry = { nixpkgs.flake = inputs.nixpkgs; };
      channel.enable = true;
      optimise.automatic = true;
      settings = {
        nix-path = config.nix.nixPath;
        experimental-features = [
          "fetch-closure"
          "flakes"
          "nix-command"
          # "repl-flakes"
        ];
        trusted-users = [ "@wheel" ];
        auto-optimise-store = false;
        builders-use-substitutes = true;
        narinfo-cache-negative-ttl = 0;
        narinfo-cache-positive-ttl = 0;
      };
    };

    home-manager.users.cbarlow = {
      programs.git = {
        userName = lib.mkForce "chandler-barlow";
        userEmail = lib.mkForce "chandlerbrlw@gmail.com";
        extraConfig = {
          commit.gpgsign = true;
          gpg.format = "ssh";
          user.signingkey = "~/.ssh/id_ed25519";
        };
      };
    };
}
