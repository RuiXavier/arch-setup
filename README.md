# arch-setup

Personal dotfiles + recovery scripts for my hand-rolled Arch + Hyprland setup.

**This is not for Omarchy.** It's the fallback for if/when I move off Omarchy and want
this exact setup back: vanilla Arch installed with `archinstall`, then Hyprland/waybar/etc.
configured by hand via the files and scripts in here.

## How this repo works

This is a ["bare repo" dotfiles setup](https://www.atlassian.com/git/tutorials/dotfiles):
`~/.dotfiles` is a bare git repo whose work tree is `$HOME` itself. There's no separate
checkout directory — the tracked files just *are* the real dotfiles in `$HOME`. `.zshrc`
defines a `config` alias for it:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

So `config status`, `config add .zshrc`, `config push` etc. all work like normal git,
just scoped to this repo instead of whatever directory you're standing in.

Two scripts do the actual work:
- **`.config/install.sh`** — fresh-machine bootstrap: installs yay, checks out all
  tracked dotfiles (backing up anything that conflicts first), installs every package
  from the lists below, restores system-level config, enables services, sets zsh as
  the shell.
- **`.config/dotfile-update.sh`** (alias `dotfile-update`) — run this on the *old*
  machine before wiping it, or periodically to keep the repo current. Exports package
  lists, snapshots `/etc` + the SDDM theme, commits, and pushes.

## Fresh install walkthrough

### 1. Run `archinstall`

Boot the Arch ISO and run `archinstall`. Settings that matter for this setup:

| Setting | Value | Why |
|---|---|---|
| Bootloader | systemd-boot | that's what's configured; see step 4 |
| Profile | **Minimal / none** — do *not* pick a Desktop or Server profile | Hyprland, waybar, SDDM etc. all come from the package lists in step 3, installed and configured by hand. A profile would fight with that. |
| Network configuration | NetworkManager | matches the package list and `install.sh`'s service-enable step |
| Kernel | `linux` | matches the package list |
| Username | **`rx`** | see [Known quirks](#known-quirks-after-restore) below — several configs hardcode `/home/rx` |
| User groups | make sure the user can `sudo` | `install.sh` needs it throughout |
| Timezone | Europe/Copenhagen | matches the old setup |
| Keyboard layout | `pt` (Portuguese) | matches `hyprland.lua`'s `kb_layout` and the old console/X11 keymap |
| Additional packages | add `git` here if archinstall offers it | saves the manual bootstrap step below; harmless either way |

Disk layout, encryption, and mirrors are just personal preference — nothing here depends
on a particular partitioning scheme. (The old setup used `zram-generator` for swap
instead of a swap partition, if you want to match that too.)

### 2. First boot — bootstrap git

If you didn't add `git` as an extra package in archinstall, the fresh install won't have
it yet, and you need it before you can even clone the dotfiles:

```bash
sudo pacman -Syu --needed git
```

### 3. Clone the dotfiles and run the installer

```bash
git clone --bare https://github.com/RuiXavier/arch-setup.git ~/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f .config/install.sh
~/.config/install.sh
```

(`install.sh` is already tracked with the executable bit set, so no `chmod` needed.)

HTTPS is used for the initial clone so it works before any SSH key exists on the new
machine; partway through its run, `install.sh` switches the remote back to SSH
(you'll need a key added to GitHub — see the note in [Known quirks](#known-quirks-after-restore)
— to `push` again afterwards, though `pull`/`checkout` from the public repo works
either way).

`install.sh` then, in order: installs `base-devel` + `yay`, checks out every tracked
dotfile (backing up anything already present to `~/.dotfiles-backup` first), installs
every package from `.config/pkglist/`, restores `/etc/pacman.conf`, `/etc/sddm.conf`,
`/etc/sddm.conf.d/`, and the SDDM theme, enables the services listed below, and sets
zsh as the login shell.

### 4. One thing archinstall/install.sh can't do for you: NVIDIA kernel params

This machine has hybrid AMD/NVIDIA graphics, and Hyprland needs two kernel parameters
that archinstall doesn't set. Edit the systemd-boot entry:

```bash
sudo nano /boot/loader/entries/*_linux.conf
```

and append to the end of the `options` line:

```
nvidia_drm.modeset=1 nvidia_drm.fbdev=1
```

(The rest of the NVIDIA setup — env vars like `LIBVA_DRIVER_NAME=nvidia`,
`GBM_BACKEND=nvidia-drm` — is already in `hyprland.lua` and gets restored automatically
in step 3.)

### 5. Reboot

```bash
reboot
```

You should land on an SDDM login screen. Log in, and Hyprland starts with everything
from `hyprland.lua` (waybar, swaync, hypridle, wallpaper slideshow, clipboard history,
etc. all autostart).

`install.sh` enables these services so the desktop actually comes up after reboot
(previously it didn't enable anything at all, which meant a "successful" run still left
you at a TTY with no display manager or network — fixed now): `NetworkManager`,
`bluetooth`, `sddm`, `docker`, `power-profiles-daemon`, `avahi-daemon`, `supergfxd`
(GPU switching daemon for the hybrid graphics, from `supergfxctl`).

## Known quirks after restore

- **Username should be `rx`.** These files hardcode `/home/rx` and will misbehave
  (wrong avatar image, wrong screenshot folder, etc. — nothing fatal) under a different
  username: `hyprland.lua` (`HYPRSHOT_DIR`), `hyprlock.conf` (lock screen avatar path),
  `qt5ct.conf`/`qt6ct.conf`, `.gtkrc-2.0`, `.zshrc` (opam/ghcup/spicetify PATH entries),
  `spicetify/config-xpui.ini`.
- **Monitor names are hardcoded** in `hyprland.lua` as `eDP-1` (laptop panel) +
  `HDMI-A-1`. Run `hyprctl monitors` after first login if outputs don't look right and
  adjust there.
- **`AQ_DRM_DEVICES` is hardcoded** to `/dev/dri/card1:/dev/dri/card0` in `hyprland.lua`.
  This should enumerate the same way on the same hardware, but if Hyprland fails to
  start or grabs the wrong GPU, check `ls /dev/dri/` and fix this env var.
- **SSH key**: not backed up by design (never commit a private key). Generate a new
  one (`ssh-keygen -t ed25519`) and add it to GitHub before you'll be able to `config
  push` again.

## Keeping it in sync

Before wiping a machine, or periodically:

```bash
dotfile-update
```

This refreshes the package lists and system-backups snapshot, then commits and pushes
whatever changed under `.config/`, `Pictures/wallpapers/`, `Current Vibe/`, `Avatar/`,
`.face/`, `.zshrc`, `.gitconfig`, `.gtkrc-2.0`, and `.zshenv`.
