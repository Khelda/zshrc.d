#
# Specific Z shell configuration for auto-ls plugin
#

function auto-ls-reset() { [[ ${WIDGET} == accept-line ]] && clear; }
function auto-ls-echo() { echo; }

function auto-ls-lsd() {
    local ignore=()
    if git status &>/dev/null
    then
        for f in $(git check-ignore *)
        do
            ignore+=("-I$f")
        done
        ignore+=("-I\\?")
    fi
    lsd --group-dirs=first "${ignore[@]}"
}

function auto-ls-readme() {
    [[ ${WIDGET} == accept-line ]] && return 0
    for f in $(find . -maxdepth 1 -iname "README*")
    do
        if [[ $f == *.[mM][dD] ]] && which -p mdcat >&/dev/null
        then
            mdcat $f
        else
            bat --style numbers,header --paging=never $f
        fi
        echo
    done
}

function auto-ls-onefetch() {
    if git status &>/dev/null
    then
        if [ -v IN_NIX_SHELL ]
        then gfi=$c_gitfetch_nix_shell_image
        else gfi=$c_gitfetch_image
        fi

        # fetching shell information
        shellname=$(basename "/"$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat \
            | cut -d \  -f 4) | tail -1 | sed 's/ .*$//'))
        backend=""

        # defining backend image-protocol
        if [[ $shellname == "kitty" ]]
        then
            backend="kitty"
        else
            backend="iterm"
        fi

        onefetch --image-protocol $backend --image $gfi --no-color-palette \
            --disabled-fields churn description dependencies contributors head created
        git status -s
        echo
    fi
}

export AUTO_LS_COMMANDS=(reset readme onefetch lsd echo)
