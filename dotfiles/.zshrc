export PATH=$HOME/dotfiles/bin:$HOME/bin:/usr/local/bin:$HOME/.local/bin:/opt/homebrew/bin:$PATH

declare -a plugins
test -f "$HOME/dotfiles/custom/zshrc_early" && source "$HOME/dotfiles/custom/zshrc_early"

_in_container () {
    test -f /.dockerenv
}

_powerlevel10k_exists () {
    test -d "$ZSH_CUSTOM/themes/powerlevel10k"
}


# Zsh early setup
test -d "$HOME/.oh-my-zsh" && {

    plugins+=(git ws)
    ZSH_CUSTOM=$HOME/dotfiles/oh-my-zsh

    ZSH_THEME=bureau

    _powerlevel10k_exists && {
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
            source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
        fi
        ZSH_THEME="powerlevel10k/powerlevel10k"
    }

}
which mise > /dev/null 2>&1 && {
    plugins+=(mise)
}

# oh-my-zsh activation
test -d "$HOME/.oh-my-zsh" && {
    export ZSH="$HOME/.oh-my-zsh"
    source $ZSH/oh-my-zsh.sh
}

##### Load shell completions if tools exist

# which direnv > /dev/null 2>&1 && eval "$(direnv hook $SHELL)" > /dev/null 2>&1
which aws_completer > /dev/null 2>&1 && complete -C '/usr/local/bin/aws_completer' aws


# Autocomplete
autoload -U promptinit; promptinit
autoload -Uz compinit && compinit -i


# Dont autoupdate brew
export HOMEBREW_NO_AUTO_UPDATE=1


## Global aliases

# Git
alias gwip='git commit -a --no-verify --no-gpg-sign -m "--wip--"'
alias gb="git branch --sort=committerdate --format=\"%(committerdate:iso)%09%(refname:short)\""
alias ggpushskipci='git push origin "$(git_current_branch)" -o ci.skip'
alias gci='git clean -id -X'

which code > /dev/null && \
  export GIT_EDITOR="code --wait"

# Mac GNU tools
test $(uname -s) = "Darwin" && {
    which gfind > /dev/null 2>&1 && alias find=gfind
    which ggrep > /dev/null 2>&1 && alias grep=ggrep
    which gsed > /dev/null 2>&1 && alias sed=gsed
}

# Docker
alias de='docker exec -ti '
alias dps="docker ps --format 'table {{.Names}}\t{{.State}}'"
alias di='docker images --format "table {{.Repository}}:{{.Tag}}" | sort'

#terraform
alias tfaa='terraform apply -auto-approve'
alias tfa='terraform apply'


# Projen
alias pj="npx projen"

# K8s
which kubectl  > /dev/null 2>&1 && alias kcontext='kubectl config set-context --current --namespace '


# Jira
which jira > /dev/null 2>&1 && eval "$(jira --completion-script-bash)"

# Jfrog CLI
test -f $HOME/.jfrog/jfrog_zsh_completion && source $HOME/.jfrog/jfrog_zsh_completion

# Vault
which vault > /dev/null 2>&1 && complete -o nospace -C `which vault` vault

# # ASDF
# which asfd > /dev/null 2>&1 && source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
# alias go-reshim='asdf reshim golang && export GOROOT="$(asdf where golang)/go/"'

which mise > /dev/null 2>&1 && {
    export MISE_GLOBAL_CONFIG_FILE=$HOME/dotfiles/dotfiles/.mise.toml
    eval "$(mise activate zsh)"
}



# Docker custom
alias dri="docker run --rm -ti"

# Mcfly https://github.com/cantino/mcfly
which mcfly > /dev/null 2>&1 && eval "$(mcfly init zsh)"

# set hostname expansion to not include known-hosts file
zstyle ':completion:*:(code|scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(code|ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(code|ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

test `uname -s` = "Darwin" && export LSCOLORS=Exfxcxdxcxegedabagacad # linux style colors

which gron > /dev/null 2>&1 && export AWS_PAGER=gron
export EDITOR=vim

# Settings for bash completion compat?
autoload -Uz +X compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
_powerlevel10k_exists && source ~/.p10k.zsh

test -f "$HOME/dotfiles/custom/zshrc_late" && source "$HOME/dotfiles/custom/zshrc_late"
_in_container || $HOME/dotfiles/scripts/attach-ssh-agent
