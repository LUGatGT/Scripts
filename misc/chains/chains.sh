#!/usr/bin/env bash
set -euo pipefail

declare -A WORDS

gen_rand() {
    MAX="$1"
    STEP=$(( 1 << 15 ))
    CURRENT=$STEP
    OUTPUT=$RANDOM

    while [[ $CURRENT -lt $MAX ]]; do
        CURRENT=$(( $CURRENT << 15 ))
        OUTPUT=$(( $OUTPUT << 15 | $RANDOM ))
    done

    echo $OUTPUT
}

norm_word() {
    local ORIGINAL_WORD="$1"
    local LOWERCASE_WORD="${ORIGINAL_WORD,,}"
    local UNC_STRIP_WORD="${LOWERCASE_WORD//[^a-z]/}"
    echo $UNC_STRIP_WORD
}

parse() {
    local PREVIOUS="-"

    for ORIGINAL_WORD in "${@:1}"; do
        local WORD=$(norm_word "$ORIGINAL_WORD")
        echo "$ORIGINAL_WORD -> $WORD"
        if [[ ! "${WORD:-}" ]]; then
            continue
        fi
        WORDS[$PREVIOUS]="${WORDS[$PREVIOUS]:-} $WORD"
        PREVIOUS=$WORD
    done
}

getword() {
    local SEED="${1:-}"
    if [[ ${SEED:-} && ${WORDS[$SEED]+_} ]]; then
        local POSSIBLE=(${WORDS[$SEED]})
    else
        local POSSIBLE=(${!WORDS[@]})
    fi
    local CHOSEN=$(( $(gen_rand ${#POSSIBLE[@]}) % ${#POSSIBLE[@]} ))
    echo "${POSSIBLE[$CHOSEN]}"
}

getwords() {
    local NUM_WORDS="$1"
    local PREVIOUS="${2:-}"

    for i in $(seq 1 $NUM_WORDS); do
        echo -n "$PREVIOUS "
        PREVIOUS=$(getword $PREVIOUS)
    done
    echo $PREVIOUS
}

generate() {
    local SOURCE="$1"
    local NUM_WORDS="$2"
    local SEED="${3:-}"

    parse $(cat "$SOURCE")
    getwords $NUM_WORDS ${SEED:-}
}

interactive() {
    local SOURCE="$1"

    echo "Parsing..."
    parse $(cat "$SOURCE")

    echo; echo "Welcome! Usage: <num words> [seed word]"
    echo "Write 'quit' to quit"

    while :; do
        echo -n '> '
        read LINE
        local DATA=($LINE)
        case "${DATA[0]:-}" in
        "")
            # ignore empty string
            ;;

        [0-9]*)
            getwords ${DATA[0]} ${DATA[1]:-}
            ;;

        quit)
            break
            ;;

        *)
            echo "Command '"${DATA[0]}"' not recognized."
            ;;
        esac
    done
}

case "${1:-}" in
generate)
    generate "$2" "${3:-}"
    ;;

interactive)
    interactive "$2"
    ;;

*)
    echo "Usage: $0 generate <file> <n words> [seed]"
    echo "Usage: $0 interactive <file>"
    ;;
esac
