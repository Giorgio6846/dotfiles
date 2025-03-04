{
#darwin-rebuild switch --flake ~/.config/nix#maclolimini
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
#    sf-pro = {
#      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
#      flake = false;
#    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
 
      nixpkgs.config.allowUnfree = true;
	
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
        pkgs.alacritty
        pkgs.neovim
        pkgs.obsidian
        pkgs.mkalias
        pkgs.tmux
        pkgs.discord
        pkgs.firefox
        pkgs.brave
        pkgs.moonlight-qt
        pkgs.vscode
        pkgs.mos
        pkgs.thunderbird
        pkgs.btop
        pkgs.htop
        pkgs.raycast
        pkgs.aerospace
        pkgs.sketchybar
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
        };
        onActivation.cleanup="zap";
        onActivation.autoUpdate=true;
        onActivation.upgrade=true;
    	};

  fonts.packages  = [
	 pkgs.nerd-fonts.jetbrains-mono
	 pkgs.nerd-fonts.roboto-mono
	];

  system.activationScripts.applications.text = let
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

      services = {
        sketchybar = {
          enable = true;
        };
      };

      system.defaults = {
        finder.ShowMountedServersOnDesktop = true;
        menuExtraClock.Show24Hour = true;

        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          _HIHideMenuBar = true;
        };

        dock = {
          autohide = true;
          persistent-apps = [
            "/System/Applications/Launchpad.app"
            "/Applications/Safari.app"
            "${pkgs.brave}/Applications/Brave\ Browser.app"
            "/System/Applications/Music.app"
            "/Applications/WhatsApp.app"
            "${pkgs.discord}/Applications//Discord.app"
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

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#maclolimini
    darwinConfigurations."maclolimini" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
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
  };
}
