{ ... }:
{

  programs.starship.enable = true;

  programs.bash = {
		enable = true;
		shellAliases = {
		  check-port = "natpmpc -g 10.2.0.1 -a 1 0 tcp 60";
			config = "zeditor ~/dotfiles";
			sw-desktop = "sudo nixos-rebuild switch --flake ~/dotfiles#desktop";
			test-desktop = "sudo nixos-rebuild test --flake ~/dotfiles#desktop";
			show-tree = "tree -a -I .git";
			vt = "cd ~/src/versustree";
			z = "zeditor .";
		};
	};
}
