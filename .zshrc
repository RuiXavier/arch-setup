# ==========================================
# ZSH CONFIGURATION & HISTORY
# ==========================================
# If not running interactively, don't do anything
[[ $- == *i* ]] || return

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ==========================================
# ALIASES
# ==========================================
alias ls='ls -alF --color=auto'
alias grep='grep --color=auto'
alias man='batman'
alias empty-trash='find ~/.local/share/Trash/files ~/.local/share/Trash/info -mindepth 1 -delete; echo "Trash emptied! :)"'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfile-update="~/.config/dotfile-update.sh"

# ==========================================
# ENVIRONMENT VARIABLES (Paths)
# ==========================================

# Currently Empty

# ==========================================
# PLUGINS & PROMPT
# ==========================================
# Enable gray auto-suggestions based on history
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable colorful commands (Green for valid, Red for typos)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize the Starship cross-shell prompt
eval "$(starship init zsh)"

# ==========================================
# GREETING
# ==========================================
fastfetch


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/rx/.opam/opam-init/init.zsh' ]] || source '/home/rx/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

[ -f "/home/rx/.ghcup/env" ] && . "/home/rx/.ghcup/env" # ghcup-env
