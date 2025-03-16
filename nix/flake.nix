{
#darwin-rebuild switch --flake ~/.config/nix#maclolimini
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    commonConfig = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      fonts.packages  = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.roboto-mono
      ];

      services = {
        sketchybar.enable = true;
      };

      system.defaults = {
        finder.ShowMountedServersOnDesktop = true;
        menuExtraClock.Show24Hour = true;

        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          _HIHideMenuBar = true;
        };
      };

      environment.systemPackages = with pkgs; [ 
        alacritty
        obsidian
        discord
        firefox
        brave
        moonlight-qt
        vscode
        mos
        thunderbird
        btop
        htop
        raycast
        aerospace
        sketchybar
      ];

      homebrew = {
        enable=true;
        brews = [
          "mas"
          "node"
          "pnpm"
          "lua"

        ]; 
        casks = [
          "font-sf-pro"
          "linearmouse"
          "the-unarchiver"
          "miniconda"
          "github"
          "beekeeper-studio"
          "elgato-camera-hub"
          "parsec"
          "syncthing"
          "sf-symbols"
          "font-hack-nerd-font"
          "via"
          "balenaetcher"
        ];
        masApps = {
          "WhatsApp Messenger" = 310633997;
          "Spark Mail" = 6445813049;
          "Velja" = 1607635845;
          "Hidden Bar" = 1452453066;
          "Windows App" = 1295203466;
          "Xcode" = 497799835;
          "DevCleaner for Xcode" = 1388020431;
          "OneDrive" = 823766827;
          "Microsoft Word" = 462054704;
          "Microsoft Excel" = 462058435;
          "KDE Connect" = 1580245991;
          "Tailscale" = 1475387142;
          "Pipifier" = 1160374471;
        };
        onActivation={
          cleanup="zap";
          autoUpdate=true;
          upgrade=true;
        };
      };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      system.stateVersion = 6;
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.activationScripts.applications.text = 
      let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';
    };
  macloliminiConfig = { pkgs, config, ... }: {
      environment.systemPackages = with pkgs; [ 
        neovim
        mkalias
        tmux
      ];

      homebrew = {
        enable=true;
        brews = [
        ]; 
        casks = [
        ];
        masApps = {
        };

    	};

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "/System/Applications/Launchpad.app"
            "/Applications/Safari.app"
            "${pkgs.brave}/Applications/Brave\ Browser.app"
            "/System/Applications/Music.app"
            "/Applications/WhatsApp.app"
            "${pkgs.discord}/Applications/Discord.app"
            "/Applications/Spark\ Desktop.app"
            "/System/Applications/Mail.app"
            "${pkgs.thunderbird}/Applications/Thunderbird\ ESR.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Books.app"
            "/System/Applications/Home.app"
            "/System/Applications/Notes.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Freeform.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "/System/Applications/App\ Store.app"
            "/System/Applications/System\ Settings.app"
            "/System/Applications/Utilities/Screen\ Sharing.app"
            "/Applications/Windows\ App.app"
            "/Applications/Parsec.app"
            "${pkgs.moonlight-qt}/Applications/Moonlight.app"
            "/System/Applications/iPhone\ Mirroring.app"
            "/Applications/Beekeeper\ Studio.app"
            "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app"
            "/Applications/Github\ Desktop.app"
            "${pkgs.alacritty}/Applications/Alacritty.app"
          ];
        };
      };
      
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };

    macloliairConfig = {pkgs, config, ...}: {
      environment.systemPackages = with pkgs; [ 
      ];

      homebrew = {
        enable=true;
        brews = [
          "wimlib"  
        ]; 
        casks = [
          "steam"
          "duet"
          "fedora-media-writer"
        ];
        masApps = {
        };
    	};

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "/System/Applications/Launchpad.app"
            "/Applications/Safari.app"
            "${pkgs.brave}/Applications/Brave\ Browser.app"
            "/System/Applications/Music.app"
            "/System/Applications/Podcasts.app"
            "/Applications/WhatsApp.app"
            "${pkgs.discord}/Applications/Discord.app"
            "/Applications/Spark\ Desktop.app"
            "/System/Applications/Mail.app"
            "${pkgs.thunderbird}/Applications/Thunderbird\ ESR.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Books.app"
            "/System/Applications/Home.app"
            "/System/Applications/Notes.app"
            "/System/Applications/Reminders.app"
            "/System/Applications/Freeform.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "/System/Applications/App\ Store.app"
            "/System/Applications/System\ Settings.app"
            "/System/Applications/Utilities/Screen\ Sharing.app"
            "/Applications/Windows\ App.app"
            "/Applications/Parsec.app"
            "${pkgs.moonlight-qt}/Applications/Moonlight.app"
            "/Applications/Beekeeper\ Studio.app"
            "${pkgs.vscode}/Applications/Visual\ Studio\ Code.app"
            "/Applications/Github\ Desktop.app"
            "${pkgs.alacritty}/Applications/Alacritty.app"
            "/Applications/Steam.app"
          ];
        };
      };
      
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    darwinConfigurations."maclolimini" = nix-darwin.lib.darwinSystem {
      modules = [
        commonConfig
        macloliminiConfig
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "giorgio6846";

      	    autoMigrate = true;
          };
        }
	    ];
    };
    darwinConfigurations."macloliair" = nix-darwin.lib.darwinSystem {
      modules = [ 
        commonConfig
        macloliairConfig
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # User owning the Homebrew prefix
            user = "giorgio6846";

      	    autoMigrate = true;
          };
        }
	    ];
    };
  };
}
