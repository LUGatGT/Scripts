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

function multiply() {
    eval local ROWS='${'${1}'[0]}'
    eval local COLS='${'${1}'[1]}'
    local SIZE=$(( $COLS * $ROWS ))
    local INITIAL=2
    eval "$3=( $ROWS $ROWS )"

    # Zero out all values
    for (( i = 2; i < $(( $SIZE + 2 )); i++)); do
        eval $3'['$i']=0'
    done

    # Check if the matrices can be multiplied
    eval local bRow='${'${2}'[0]}'
    eval local bCol='${'${2}'[1]}'
    if [ $COLS -ne $bRow ]; then
        echo "Cannot multiply a ${ROWS}x${COLS} matrix by a ${bRow}x${bCol}!"
        return 1
    fi

    for (( i = 0; i < $(( $ROWS * $COLS * $bCol )); i++ )); do
        # Update RowWise index
        COLWISE=$(( ( $i % $COLS ) + ( $i / $SIZE ) * $COLS + $INITIAL ))
        # Update ColWise index
        ROWWISE=$(( ( ( $i * $ROWS ) % $SIZE ) + ( ( $i / $COLS ) % $ROWS ) + $INITIAL ))
        # Update of resulting product
        PRODUCT=$(( $i / $COLS + $INITIAL ))
        # Multiply together!
        eval $3'['$PRODUCT']=$( echo ${'$3'['$PRODUCT']} + ${'$1'['$ROWWISE']} "*" ${'$2'['$COLWISE']} | bc )'
    done
}

function printMatrix() {
    eval local ROWS='${'${1}'[0]}'
    eval local COLS='${'${1}'[1]}'
    local SIZE=$(( $COLS * $ROWS + 2 ))

    for (( i = 2; i < $SIZE; i++ )); do
        eval echo -e -n '${'${1}'['${i}']} \\t'
        # Newlines are different rows
        if [ $(( ( $i - 2 ) % $COLS )) -eq $(( $COLS - 1 )) ]; then
            echo
        fi
    done
}

function demo() {
    MATRIXA="1 -2 3
             4  5 6
             7  8 9"

    MATRIXB="1   2   3
             4   5   6
             7   8   9
            10  11  12"

    hardMatA="317090.12348131  -292842.97355444  -414621.40659565   218936.56232317
             -132483.29792003   138589.92469273   100121.49612951  -486183.34557993
             -165215.44259611  -133545.4644489   -120089.09255085  -208088.98954047"

    hardMatB="343892.11506608  267636.00083847  232678.62132651
              159439.31437977 -162335.62953134 -368544.26408328
             -70015.99684037   456307.7552861   241007.55188952
              96512.85199926   341083.0534365  -247618.36002464"

    toMatrix "$MATRIXA" aMatrix
    toMatrix "$MATRIXB" bMatrix

    multiply aMatrix bMatrix result


    echo "Trying next matrix!"

    toMatrix "$hardMatA" MatA
    toMatrix "$hardMatB" MatB

    echo; echo "Completed in:"
    time multiply MatA MatB MatResult

    echo; echo "Result"
    printMatrix MatResult
}

demo
