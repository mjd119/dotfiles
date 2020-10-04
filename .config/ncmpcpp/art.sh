#!/usr/bin/env sh

#-------------------------------#
# Generate current song cover   #
# ffmpeg version                #
#-------------------------------#
#
# Modified from .ncmpcpp directory from https://gitlab.com/sourplum/dotfiles by mjd119
MUSIC_DIR="$HOME/Music"
COVER="/tmp/cover.png"
TEMP_COVER="/tmp/temp_cover.png"
COVER_SIZE=1000

BORDERS=false
BORDER_WIDTH=5
BORDER_COLOR="white"

function ffmpeg_cover {
    if $BORDERS; then
        ffmpeg -loglevel 0 -y -i "$1" -vf "scale=$COVER_SIZE:-1,pad=$COVER_SIZE+$BORDER_WIDTH:ow:(ow-iw)/2:(oh-ih)/2:$BORDER_COLOR" "$COVER"
    else
        #ffmpeg -loglevel 0 -y -i "$1" -vf "scale=$COVER_SIZE:-1" "$COVER"
        ffmpeg -loglevel 0 -y -i "$1" -vf "scale=$COVER_SIZE:-1" "$TEMP_COVER"
        if [ $(stat -c%s $TEMP_COVER) -eq $(stat -c%s $COVER) ]; then # Don't overwrite file if the size is the same so there isn't a flash after changing song on same album and less obvious flash when album does change
            true
        else
            cp $TEMP_COVER $COVER
        fi
    fi
}

function fallback_find_cover {
    album="${file%/*}"
    album_cover="$(find "$album" -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(cover?s\|folder?s\|artwork?s\|front?s\|scan?s\).*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album" -type d -exec find {} -maxdepth 1 -type f -iregex ".*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album/.." -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(cover?s\|folder?s\|artwork?s\|front?s\|scan?s\|booklet\).*?1[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi
    album_cover="$(echo -n "$album_cover" | head -n1)"
}
# Function added by mjd119 to fit my needs (prioritize images in parent directory for double albums)
function find_cover_parent {
    album="${file%/*}" # Start in parent directory (traverse down)
    # Look for Album file in parent directory first (useful for double albums with separate folders for discs)
    album_cover="$(find "$album/.." -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(album\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    # Look for Album file in current directory
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album" -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(album\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi


    # Look for Folder file in parent directory first (useful for double albums with separate folders for discs)
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album/.." -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(folder\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi
    # Look for Folder file in current directory
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album" -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(folder\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi


    # Look for Cover file in parent directory first (useful for double albums with separate folders for discs)
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album/.." -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(cover\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi
    # Look for Cover file in current directory
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album" -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(cover\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi


    # Look for Front file in parent directory first (useful for double albums with separate folders for discs)
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album/.." -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(front\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi
    # Look for Front file in current directory
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album" -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*\(front\)[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi


    # Look for other files in parent directory first (useful for double albums with separate folders for discs) [lazy method]
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album/.." -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi
    # Look for other files in current directory (lazy method)
    if [ "$album_cover" == "" ]; then
        album_cover="$(find "$album" -maxdepth 0 -type d -exec find {} -maxdepth 1 -type f -iregex ".*[.]\(jpe?g\|png\|gif\|bmp\)" \;)"
    fi

    # Use placeholder image if an album cover file is not found
    if [ "$album_cover" == "" ]; then
        album_cover="$HOME/.config/ncmpcpp/Missing_Art.jpg"
    fi
    #echo $album
    #echo $album_cover
    album_cover="$(echo -n "$album_cover" | head -n1)"
    #echo $album_cover
}

{
    file="$MUSIC_DIR/$(mpc --format %file% current)"

    if [[ -n "$file" ]] ; then
       # Commented out so embedded artwork is completely avoided (mjd119)
       # if ffmpeg_cover "$file"; then
        #    exit
       # else
            #fallback_find_cover
        find_cover_parent
        ffmpeg_cover "$album_cover"
       # fi
    fi
} &
