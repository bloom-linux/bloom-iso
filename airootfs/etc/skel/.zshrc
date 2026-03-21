# Bloom zshrc
export EDITOR=neovim
export VISUAL=neovim

# History
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory sharehistory incappendhistory

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Prompt — simple single-line with color
autoload -Uz colors && colors
PROMPT="%F{red}❀%f %F{white}%~%f %F{red}›%f "

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias vi=nvim
alias vim=nvim

# fastfetch only inside kitty (not on raw tty or other contexts)
if [[ -n "$KITTY_WINDOW_ID" ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
