#!/usr/bin/env bash
# Author michael <themichaeleden@gmail.com>
set -euo pipefail

SNAKE_CASE_FILE="$(mktemp)"

# gather all the camel case in the source
grep -P -R -o -h ' ([a-z0-9]+_)+[a-z0-9]+' | sort -u > "$SNAKE_CASE_FILE"

# let user filter which ones they want to replace
${EDITOR:-vi} "$SNAKE_CASE_FILE"

# change all snake case with camel case
CAMEL_CASE=$(cat "$SNAKE_CASE_FILE" | sed -e 's/\(_\)\(.\)/\U\2/g')

# do the replacing on the source files
paste "$SNAKE_CASE_FILE" <(echo "$CAMEL_CASE") | while read REPLACE; do
    PAIR=( $REPLACE )
    find . -type f -print | while read SOURCE; do
        echo "In '$SOURCE', replacing '${PAIR[0]}' with '${PAIR[1]}'"
        sed -i "s/\(^\|[^_a-z0-9]\)${PAIR[0]}\($\|[^_a-z0-9]\)/\1${PAIR[1]}\2/g" "$SOURCE"
    done
done

# cleanup
rm -f "$SNAKE_CASE_FILE"

