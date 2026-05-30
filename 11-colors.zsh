declare -A c_fetch_image
declare -A c_kitty_opacity

declare -A colors_light colors_dark

# Icons paths
ICONS_PATH="$ZSH_CONFIG_PATH/res/fetch_imgs" # root path
c_fetch_image[dark]="$ICONS_PATH/fetch_image.jpg"
c_gitfetch_nix_shell_image="$ICONS_PATH/gitfetch_nix_shell_image.jpg"
c_gitfetch_image="$ICONS_PATH/gitfetch_image.jpg"

# Opacity values for _kitty_color
c_kitty_opacity[dark]="0.8"
c_kitty_opacity[light]="0.8"

# Colorscheme
colors_light[goyo_bg]="#d9d9da"
colors_dark[goyo_bg]="#0f2228"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

[ -f "$HOME/.zsh-colors" ] && source "$HOME/.zsh-colors"

# ASCII colors, useful sometimes
function colors::palette() {
    for i in {0..255}
    do
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " \
            ${${(M)$((i%6)):#3}:+$'\n'}
    done
}

function colors::ascii() {
    val=$1 # rgb color
    foundDist=1000
    color=""
    for line in $(cat $ZSH_CONFIG_PATH/res/colors.csv | grep "#")
    do
        # parsing color line
        ascii_col=$(echo $line | cut -d ';' -f 1)
        rgb_col=$(echo $line | cut -d ';' -f 2)
        # distance comparison
        dist=$($ZSH_CONFIG_PATH/res/colors.py $val $rgb_col)
        if [[ $foundDist -ge $dist ]]
        then
            # found closer color
            foundDist=$dist
            color=$ascii_col
        fi
    done
    # output a color
    if [[ $foundDist -le 0 ]]
    then
        >&2 echo "Found exact color match :"
        print -Pn "%K{$color}  %k%F{$color}$color%f " \
            ${${(M)$(0):#3}:+$'\n'}
    else
        >&2 echo "Couldn't find match for $val. Closest color is :"
        print -Pn "%K{$color}  %k%F{$color}$color%f " \
            ${${(M)$(0):#3}:+$'\n'}
    fi
}

function colors::rgb() {
    val=$1 # ascii color
    # length fix
    if [[ ${#val} -le 2 ]]
    then
        if [[ ${#val} -eq 1 ]]
        then
            val="00$val"
        else
            val="0$val"
        fi
    fi
    # fetching color
    col_line=$(cat $ZSH_CONFIG_PATH/res/colors.csv | grep "$val;") # FIXME
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
