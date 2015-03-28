#!/bin/bash

function getElm() {
    echo "$1" | sed -n ${2}p | cut -d " " -f $3
}

function toMatrix() {
    local SEQ=""
    local INDEX=2
    local ROWS=$( echo "$1" | wc -l )
    local COLS=$( echo "$1" | head -1 | wc -w )
    eval "$2=( $ROWS $COLS )"

    while read -r ROW; do
        for E in $ROW; do
            eval "$2[$INDEX]=$E"
            INDEX=$(( $INDEX + 1 ))
        done
    done < <(echo "$1")
}

function traverseRow() {
    SEQ=""
    ROWS=$( echo "$1" | wc -l )
    COLS=$( echo "$1" | head -1 | wc -w )
    while read -r ROW; do
        for E in $ROW; do
            SEQ="$SEQ $E"
        done
    done < <(echo "$1")
    echo "${ROWS} ${COLS}${SEQ}"
}

function traverseCol() {
    SEQ=""
    MATRIX="$1"
    ROWS=$( echo "$MATRIX" | wc -l )
    COLS=$( echo "$MATRIX" | head -1 | wc -w )

    for COL in {1..$COLS}; do
        for ROW in {1..$ROWS}; do
            NEXT=$(getElm "$MATRIX" $ROW $COL)
            SEQ="$SEQ $NEXT"
        done
    done


}


function multiply() {
    aMatrix="$1"
    aRows=$( echo "$aMatrix" | wc -l )
    aCols=$( echo "$aMatrix" | head -1 | wc -w )
    bMatrix="$2"
    bRows=$( echo "$bMatrix" | wc -l )
    bRows=$( echo "$bMatrix" | head -1 | wc -w )

    aRow=1
    aCol=1
    bRow=1
    bCol=1

    while [ $aRow -le $aRows ]; do
        while [ $aCol -le $aCols ]; do

}

MATRIXA="1 0 0
0 1 0
0 0 1"

toMatrix "$MATRIXA" MATRIX

ROWS=${MATRIX[0]}
COLS=${MATRIX[1]}
SIZE=$(( $COLS * $ROWS + 2 ))

OFFSET=2
COLWISE=2
CELL=0
PRODUCT=1
CELLPOS=0

for (( i = 2; i < $(( $SIZE * 2 )); i++ )); do
    # Do something with the index
    echo -e "$i \t $COLWISE"
    # Update the index of col wise
    COLWISE=$(( $COLWISE + $COLS ))
    if [ $COLWISE -ge $SIZE ]; then
        OFFSET=$(( $OFFSET + 1 ))
        if [ $OFFSET -eq $(( $COLS + 2 )) ]; then
            OFFSET=2
        fi
        COLWISE=$OFFSET
    fi
    # Update the index of row wise

done