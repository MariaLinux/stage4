{ config, lib, pkgs, nixgl, ... }:

{

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  # nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "mesa" ];

  home.username = "@USERNAME@";
  home.homeDirectory = "@HOMEDIR@";

  home.stateVersion = "24.11"; 


  home.packages = [
    (config.lib.nixGL.wrap pkgs.ghostty)
    (config.lib.nixGL.wrap pkgs.ente-auth)
    (config.lib.nixGL.wrap pkgs.firefox)
    (config.lib.nixGL.wrap pkgs.telegram-desktop)
    (config.lib.nixGL.wrap pkgs.vlc)
    (config.lib.nixGL.wrap pkgs.rustdesk)
    (config.lib.nixGL.wrap pkgs.vscode)
    #(config.lib.nixGL.wrap pkgs.gimp-with-plugins)
    (config.lib.nixGL.wrap pkgs.file-roller)
    (config.lib.nixGL.wrap pkgs.gnome-console)
    (config.lib.nixGL.wrap pkgs.gnome-calculator)
    (config.lib.nixGL.wrap pkgs.libreoffice)
    (config.lib.nixGL.wrap pkgs.google-chrome)
    (config.lib.nixGL.wrap pkgs.inkscape-with-extensions)
    (config.lib.nixGL.wrap pkgs.shotwell)
    (config.lib.nixGL.wrap pkgs.skypeforlinux)
    (config.lib.nixGL.wrap pkgs.obs-studio)
    pkgs.htop
    pkgs.joplin-desktop
    pkgs.rpm
    pkgs.axel
    pkgs.gnome-sound-recorder
    pkgs.cheese
    pkgs.meld
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

 
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {
	home-manager.enable = true;
	bash.enable = true;
	direnv = {
		enable = true;
		enableBashIntegration = true;
		nix-direnv.enable = true;
	};
  };
}
