#!/bin/bash
#Created by Collin Richards

IMAGE_FILE='image.jpg'
USER_AGENT='Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:35.0) Gecko/20100101 Firefox/35.0'
TEXT=$(fortune) #TODO escape strings with '
IMAGE_URL=$(curl -A "$USER_AGENT" http://photo.net/photodb/random-photo?category=NoNudes 2>/dev/null \
    | grep 'class=""' \
    | awk -F ' ' '{print $3}' \
    | cut -c 6- \
    | rev | cut -c 2- | rev)

curl -A "$USER_AGENT" "$IMAGE_URL" -o "$IMAGE_FILE"

# A solution to prevent cutting off the edges of the text
# and choose a good text color would be cool.

mogrify -pointsize 24 \
    -gravity north \
    -fill red \
    -stroke red \
    -font Helvetica \
    -draw "text 30,10 '$TEXT'" \
    "$IMAGE_FILE"

xdg-open "$IMAGE_FILE"
