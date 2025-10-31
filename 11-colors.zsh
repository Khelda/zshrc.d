declare -A c_fetch_image
declare -A c_kitty_opacity

declare -A colors_light colors_dark

# Icons paths
ICONS_PATH="$HOME/.config/fetch_imgs" # root path
c_fetch_image[dark]="$ICONS_PATH/fetch_image.png"
c_gitfetch_nix_shell_image="$ICONS_PATH/gitfetch_nix_shell_image.png"
c_gitfetch_image="$ICONS_PATH/gitfetch_image.png"

# Opacity values for _kitty_color
c_kitty_opacity[dark]="0.8"
c_kitty_opacity[light]="0.8"

# Colorscheme
colors_light[goyo_bg]="#d9d9da"
colors_dark[goyo_bg]="#4d4d4d"
colors_dark[pgcli_bg]="#444444"
colors_light[pgcli_bg]="#444444"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

[ -f "$HOME/.zsh-colors" ] && source "$HOME/.zsh-colors"

# ASCII colors, useful sometimes
function colors::ascii() {
    for i in {0..255}
    do
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " \
            ${${(M)$((i%6)):#3}:+$'\n'}
    done
}

function colors::rgb() {
    val=$1 # ascii color
    # fetching color
    col_line=$(cat $ZSH_CONFIG_PATH/res/colors.csv | grep "$val;")
    if [[ -z $col_line ]]
    then
        >&2 echo "Color $val is not an ascii color"
        return
    fi
    # parsing color line
    ascii_col=$(echo $col_line | cut -d ';' -f 1)
    rgb_col=$(echo $col_line | cut -d ';' -f 2)
    # printing the fetched color
    print -Pn "%K{$rgb_col}  %k%F{$ascii_col}$rgb_col%f " \
        ${${(M)$(0):#3}:+$'\n'}
}

# vim: ft=zsh
