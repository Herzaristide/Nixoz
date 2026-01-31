{ config, pkgs, dotfilesDir ? "", ... }:

let
  dotfilesPath = if dotfilesDir != "" then dotfilesDir else "${config.home.homeDirectory}/.dotfiles";
in {

######################### fish config #########################################

	programs.fish = {
	  enable = true;
	  
	  shellInit = ''
		if test -d ~/bin
        set -gx PATH ~/bin $PATH
		  end
	  '';

	  interactiveShellInit = ''
		if status is-interactive
			${pkgs.fastfetch}/bin/fastfetch
		  end

		# Atuin (history)
		${pkgs.atuin}/bin/atuin init fish | source
		
		# Zoxide (directory jumping)
		${pkgs.zoxide}/bin/zoxide init fish | source

		# Direnv (environment)
        ${pkgs.direnv}/bin/direnv hook fish | source

		#starship
		${pkgs.starship}/bin/starship init fish | source
	  '';

	  shellAbbrs = {
		n = "nvim";
		ga = "git add .";
		gs = "git status";
		gm = "git commit -m ";
		gp = "git push";
		rebs = "sudo nixos-rebuild switch --flake ${dotfilesPath}";
		reb = "sudo nixos-rebuild test --flake ${dotfilesPath}";
		conf = "nvim ${dotfilesPath}/configuration.nix";
		hom = "nvim ${dotfilesPath}/home.nix";
		homs = "home-manager switch --flake ${dotfilesPath}";
		homb = "home-manager build --flake ${dotfilesPath}";
		shell = "nix-shell";
		ais = "sudo systemctl stop ollama.service";
		ai = "sudo systemctl start ollama.service";
		qwen = "ollama run qwen2.5-coder:1.5b";
		bluetooth = "python3 ~/Programming/python/pyprojects/bluetooth/bluetooth.py";
		imgsort = "python3 ~/Programming/python/pyprojects/imagesorter/imagesorter.py";
		tlp = "sudo tlp start";
		rmgen = "python3 ~/Programming/python/pyprojects/homgenremover/homgenremover.py";
		gen = "home-manager generations";
	  };

	  functions = {
		y = ''
		  set tmp (mktemp -t "yazi-cwd.XXXXXX")
		  yazi $argv --cwd-file="$tmp"
		  set cwd (cat "$tmp")
		  if test -n "$cwd" && test "$cwd" != "$PWD"
			cd "$cwd"
		  end
		  rm -f "$tmp"
		'';
	  };

	};

}

###############################################################################

