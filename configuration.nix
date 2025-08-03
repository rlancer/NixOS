# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>    
];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver ={
    enable = true;
    # dpi = 180; - doesnt help
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;


  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
   [org.gnome.mutter]
   experimental-features=['scale-monitor-framebuffer']
 '';
  };

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
# trying to show battery life in gnome
hardware.bluetooth.settings = {
	General = {
		Experimental = true;
	};
};  
# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Rootless mode might of broke vscode 
#  virtualisation.docker.rootless = {
#     enable = true;
#     setSocketVariable = true;
#   };

virtualisation.docker.enable = true;
users.extraGroups.docker.members = [ "rob" ];

fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rob = {
    isNormalUser = true;
    description = "Rob";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
programs.direnv.enable = true; 
programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;
home-manager.useGlobalPkgs = true; # https://discourse.nixos.org/t/home-manager-does-not-allowunfree/25681/5 - fixed unfree issue for home manager
home-manager.users.rob = { pkgs, ... }: {
  home.packages = [ 
    pkgs.jq
    pkgs.file
    pkgs.python313
    pkgs.gcc
    pkgs.gnupg
    pkgs.atool 
    pkgs.ghostty
    pkgs.httpie 
    pkgs.adw-gtk3
    pkgs.gnomeExtensions.bluetooth-battery-meter
    pkgs.gnomeExtensions.screenshot-tool
    pkgs.gnumake
    pkgs.xsel
    pkgs.ansible
    pkgs.duckdb
  ];
        
  # xdg.mimeApps = {
  #  enable = true
  #  defaultApplications = {"":""};
  # };


  programs.bash.enable = true;
  programs.git = {
 	enable = true;
  	userEmail = "robert.lancer@gmail.com";
  	userName = "Robert Lancer";
  };
  
  programs.git.extraConfig = {
    init.defaultBranch = "main";
    core = {
      editor = "vim";
    };
    safe.directory = ["/etc/nixos"];
  };
 
 programs.awscli = {
   enable = true;
 };

 programs.vscode = {
   enable = true;
   profiles.default = {
      extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      # vscodevim.vim
      jnoortheen.nix-ide
      yzhang.markdown-all-in-one
      ms-vscode-remote.remote-containers
      github.copilot
      ms-azuretools.vscode-docker
      eamodio.gitlens
      github.copilot-chat
      github.vscode-github-actions
      donjayamanne.githistory
      esbenp.prettier-vscode
    ];

    userSettings = {
        # "files.autoSave" = "off";
       # "[nix]"."editor.tabSize" = 2;
     # "workbench.preferredDarkColorTheme" = "Default Dark Modern";
     # "workbench.preferredLightColorTheme" = "Default Light Modern";
   };
  };
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline ];
    settings = { ignorecase = true; };
    extraConfig = ''
      set mouse=a
    '';
  };

  # Style 
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # scaling-factor = 2; # this didnt work
      gtk-theme = "adw-gtk3-dark";
      clock-format = "12h";
   };
   "org/gnome/shell/overrides" = {
      edge-tiling = true;
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "bluetooth-battery-meter" "screenshot-tool"
    ];
  };
};


   programs.zed-editor = {
        enable = true;
        extensions = ["nix" "toml" "elixir" "make"];

        ## everything inside of these brackets are Zed options.
        userSettings = {

            


            auto_update = false;



            lsp = {
                rust-analyzer = {

                    binary = {
                        #                        path = lib.getExe pkgs.rust-analyzer;
                        path_lookup = true;
                    };
                };
                nix = {
                    binary = {
                        path_lookup = true;
                    };
                };

                elixir-ls = {
                    binary = {
                        path_lookup = true;
                    };
                    settings = {
                        dialyzerEnabled = true;
                    };
                };
            };


            load_direnv = "shell_hook";
        };

   
      };

  programs.zsh = {
    enable = true;
    shellAliases = {
      upgrade = "sudo nixos-rebuild switch --upgrade";
      update = "sudo nixos-rebuild switch";
      edit = "sudo vim /etc/nixos/configuration.nix";
   };

   initContent = ''
     eval "$(starship init zsh)"
    ''; 

   oh-my-zsh = {
    enable = true;
    plugins = [ ];
    theme = "agnoster";
  };
 };
  
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
};

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    postman
   unzip
   google-chrome
   slack
   zoom-us
   docker-compose
   devenv
   libreoffice
   heroku
   inkscape
   dbeaver-bin

 ];

 # Enable Nix Flakes

 nix.settings.experimental-features = [ "nix-command" "flakes" ];

 nix.settings = {
    substituters = [ "https://nixpkgs-ruby.cachix.org" "https://cache.nixos.org/" ];
    trusted-users = ["root" "rob"];
    trusted-substituters = [ "https://cache.flox.dev" ];
    trusted-public-keys = [ 
      "nixpkgs-ruby.cachix.org-1:RKp+M/Y29IP0kf2VJQqRZeoZaWNXdu63iNufz8kCiBQ="
      "cache.nixos.org-1:LS3WLTDzZ58H2LuW5NkLMbe1HAYs4szPvCBTxj4gS3E="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
networking.extraHosts =
  ''
    127.0.0.1 robslocal
  '';

system.autoUpgrade.enable = true;
system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
system.autoUpgrade.allowReboot = false;


# This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
