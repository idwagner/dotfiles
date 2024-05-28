#!/bin/bash
set -eu

export ROOT=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)
export DOTFILES="$ROOT/dotfiles"
export CUSTOM="$ROOT/custom/dotfiles"

info () {
    echo "INFO: " "$@" >&2
}

all_dotfiles () {

    for basedir in $1; do
        pushd "$basedir" > /dev/null 2>&1
        find . -type f -print | sed 's/^\.\///'
        popd > /dev/null 2>&1
    done

}

get_preferred_dotfiles () {

    local subdirs=()
    test -d "$ROOT/custom/dotfiles" && subdirs+=("$ROOT/custom/dotfiles")
    subdirs+=("$ROOT/dotfiles")

    for file in $(all_dotfiles "${subdirs[@]}"); do

        for basedir in "${subdirs[@]}"; do
            if [ -e "$basedir/$file" ]; then
                echo "$file $basedir/$file"
                break
            fi
        done
    done

}


ts=$(date +%s)
get_preferred_dotfiles | while read dotfile source; do

    target_dir=$(dirname "$dotfile")
    if [ ! -d "$HOME/$target_dir" ]; then
        info "Creating directory $HOME/$target_dir"
        mkdir -p "$HOME/$target_dir"
    fi

    if [ -h "$HOME/$dotfile" ]; then
        curtarget="$(readlink -f "$HOME/$dotfile" || true)"
        if [ "$curtarget" = "$source" ]; then
            continue
        fi
        info "Replacing old symlink of $dotfile > $curtarget"
        rm "$HOME/$dotfile"
    elif [ -d "$HOME/$dotfile" ]; then
        info "Target \$HOME/$dotfile is currently a directory. Will not replace"
        continue
    elif [ -f "$HOME/$dotfile" ]; then
        info "Moving old target $HOME/$dotfile to $HOME/$dotfile.$ts"
        mv "$HOME/$dotfile" "$HOME/$dotfile.$ts"
    fi

    ln -s "$source" "$HOME/$dotfile"

done

test -d "$ROOT/oh-my-zsh/themes/powerlevel10k" || {
    git clone https://github.com/romkatv/powerlevel10k.git "$ROOT/oh-my-zsh/themes/powerlevel10k"
}

test -d "$HOME/.oh-my-zsh" || {
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
}
