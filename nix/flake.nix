{
#darwin-rebuild switch --flake ~/.config/nix#maclolimini
  description = "Nix Flakes for Macloli-Mini and Macloli-Air";

  nixConfig = {
    trusted-substituters = [
      "https://xixiaofinland.cachix.org"
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
    ];
    trusted-public-keys = [
      "xixiaofinland.cachix.org-1:GORHf4APYS9F3nxMQRMGGSah0+JC5btI5I3CKYfKayc="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    }; 

    
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask}:
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

      system={
          primaryUser = "giorgio6846";
          defaults = {
          finder.ShowMountedServersOnDesktop = true;
          menuExtraClock.Show24Hour = true;

          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            _HIHideMenuBar = true;
          };
        };
      };

      environment.systemPackages = with pkgs; [ 
        aerospace
        btop
        htop
        tmux
        moonlight-qt
        vscode
        mos
        thunderbird
        raycast
        sketchybar
      ];

      homebrew = {
        enable=true;
        brews = [
          "gh"
          "mas"
          "node"
          "pnpm"
          "lua"
          "pyenv"
      	  "awscli"
        ]; 
        casks = [
          "syncthing-app"
          "alacritty"
          "caffeine"
          "firefox"
          "brave-browser"
          "discord"
          "obsidian"
          "font-sf-pro"
          "vlc"
          "handbrake"
          "linearmouse"
          "the-unarchiver"
          "miniconda"
          "github"
          "beekeeper-studio"
          "elgato-camera-hub"
          "parsec"
          "sf-symbols"
          "font-hack-nerd-font"
          "via"
          "balenaetcher"
          "nvidia-nsight-systems"
          "mendeley-reference-manager"
          "omnidisksweeper"
          "vnc-viewer"
          "pgadmin4"
          "wireshark-app"
          "zerotier-one"
        ];

        taps = [ 
          "mas-cli/tap"
          "deskflow/homebrew-tap"
        ];

        masApps = {
          "WhatsApp Messenger" = 310633997;
          "Velja" = 1607635845;
          "Hidden Bar" = 1452453066;
          "Windows App" = 1295203466;
          "Xcode" = 497799835;
          "DevCleaner for Xcode" = 1388020431;
          "OneDrive" = 823766827;
          "Microsoft Word" = 462054704;
          "Microsoft Excel" = 462058435;
	        "Microsoft Powerpoint" = 462062816;
          "KDE Connect" = 1580245991;
          "Tailscale" = 1475387142;
          "Pipifier" = 1160374471;
          "Microsoft Outlook" = 985367838;
        };
        onActivation={
          cleanup="zap";
          autoUpdate=true;
          upgrade=true;
        };
      };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.enable = false;	

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
          "coreutils"
          "make"
          "gcc@12"
          "lowdown"
          "openjdk"
          "virt-viewer"
        ]; 
        casks = [
          "blender"
          "obs"
          "hdfview"
        ];
        taps = [ 
          "jeffreywildman/homebrew-virt-manager"
        ];
        masApps = {
          "DaVinci Resolve" = 571213070;
          "PocketPal" = 1538263296;
          "Octal for Hacker News" = 1308885491;
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
            "/System/Applications/Mail.app"
            "/Applications/Microsoft\ Outlook.app"
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
          "cbonsai"
        ]; 
        casks = [
          "steam"
          "duet"
          "fedora-media-writer"
          "raspberry-pi-imager"
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
            "/System/Applications/Mail.app"
            "/Applications/Microsoft\ Outlook.app"
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
