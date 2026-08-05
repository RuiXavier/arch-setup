# ~/.zshenv - Read by all Zsh processes (GUI, background, and terminal)

# Spicetify
export PATH="$PATH:$HOME/.spicetify"

# TeX Live 2026
export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
export MANPATH="/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH"

export QT_QPA_PLATFORM="wayland;xcb"
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1
export OZONE_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
