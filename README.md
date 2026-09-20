# dotfiles

NixOS configuration, built with flake-parts. One host today (`desktop`);
laptop and WSL hosts planned.

## Layout

```
hosts/      per-machine config (composition, hardware, host-specific bits)
features/   host-agnostic modules with enable options
modules/    shared system plumbing (boot, audio, locale, secrets, ...)
home/       home-manager config (user, dotfiles, scripts)
themes/     stylix base16 schemes
```
