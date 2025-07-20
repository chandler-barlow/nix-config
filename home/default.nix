{ pkgs, ... }:
{
  imports = [];

  home = {
    username = "cbarlow";
    homeDirectory = "/home/cbarlow";
    sessionPath = [ "$HOME/bin" ];
    sessionVeriables = {
      EDITOR = "hx";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };  

    shellAliases = {
      rebuild-vm = "sudo nixos-rebuild switch --flake .#cbarlow-vm";
    };

    stateVersion = "21.05";

    packages = with pkgs [
      fd
      sd
      jq
      nil
      nixpkgs-fmt
      nix-output-monitor
      fzf
      btop
      cabal2nix      
    ];

    programs = {
      home-manager.enable = true;

      fish.enable = true;

      zellij.enable = true;

      git = {
        enable = true;
        userName = "chandler-barlow";
        email = "chandlerbrlw@gmail.com";
        extraConfig = {
          user.signingKey = "~/.ssh/id_ed25519";
          gpg.format = "ssh";
          commit.gpgsign = true;
          tag.gpgsign = true;
          diff.colorMoved = "default";
          init.defaultBranch = "master";
          rerere.enabled = true;
        };
        ignores = [
          "result"
          ".direnv"
          ".envrc"
          "dist-newstyle"
        ];
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      helix = {
        enable = true;
        languages = {
          language-server = {
            haskell-language-server.command = "haskell-language-server";
            haskell-language-server.config.haskell = {
              formattingProvider = "ormolu";
              plugin.fourmolu.config.external = ture;
            };
            nil.command = "nixd";
          };
        };
        settings.editor = {
          true-color = true;
          color-mode = true;
          cusorline = true;
        };
        settings.editor.indent-guides = {
          render = true;
          skip-levels = 1;
        };
        settings.editor.lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        settings.theme = "material_darker";
      };
    };
  };
}
