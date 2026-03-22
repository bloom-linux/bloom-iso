# ── Bloom zshrc ────────────────────────────────────────────────────────────────

export EDITOR=nvim
export VISUAL=nvim
export TERM=xterm-256color
export COLORTERM=truecolor

# ── History ────────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory incappendhistory histignorealldups histignorespace

# ── Completion ─────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*'           menu select
zstyle ':completion:*'           matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:default'   list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:warnings'  format '%F{red}no matches%f'
zstyle ':completion::complete:*' gain-privileges 1

# ── Options ────────────────────────────────────────────────────────────────────
setopt autocd autopushd pushdignoredups
setopt interactivecomments
setopt nocaseglob extendedglob
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# ── Prompt ─────────────────────────────────────────────────────────────────────
autoload -Uz colors vcs_info && colors

zstyle ':vcs_info:*'         enable git
zstyle ':vcs_info:git:*'     formats       ' %F{#9B5FC0}%b%f%F{#B01828}%m%u%c%f'
zstyle ':vcs_info:git:*'     actionformats ' %F{#9B5FC0}%b%f %F{yellow}(%a)%f'
zstyle ':vcs_info:git:*'     stagedstr     '%F{#7AB87A} ●%f'
zstyle ':vcs_info:git:*'     unstagedstr   '%F{#D4A44C} ●%f'
zstyle ':vcs_info:*'         check-for-changes true

precmd() {
    vcs_info
    [[ -n "$VIRTUAL_ENV" ]] && _venv=" %F{#4A9DA8}($(basename "$VIRTUAL_ENV"))%f" || _venv=""
}

# Two-line prompt:
#  ❀ user in ~/path  branch ●
#  › (red=ok, yellow=error)
setopt prompt_subst
PROMPT='
%F{#B01828}❀%f %F{#88809A}%n%f %F{#3D3450}in%f %F{#F0EEF4}%B%~%b%f${vcs_info_msg_0_}${_venv}
%(?.%F{#B01828}.%F{#D4A44C})›%f '

RPROMPT='%F{#3D3450}%*%f'

# ── Aliases ────────────────────────────────────────────────────────────────────
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah --color=auto --group-directories-first'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias vi='nvim'
alias vim='nvim'
alias tree='tree -C'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias pacup='sudo pacman -Syu'
alias pacrm='sudo pacman -Rns'
alias pacq='pacman -Ss'

# ── fastfetch on new terminal window ──────────────────────────────────────────
if [[ -n "$ALACRITTY_WINDOW_ID" || -n "$KITTY_WINDOW_ID" ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
