
ws () {

    workspace="$HOME/code/vscode-workspaces/${1}.code-workspace"
    if [ -f "$workspace" ]; then
        open "$workspace"
    fi

}
