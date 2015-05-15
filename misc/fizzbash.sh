#!/bin/bash

# Takes a range (a, b] and prints all the numbers in this range
# Does FizzBuzz!

function fizzbash() {
    if [ $1 -eq $2 ]; then
        return 0
    fi

    OUT=""
    if [ $(( $1 % 3 )) -eq 0 ]; then
        OUT="Fizz"
    fi
    if [ $(( $1 % 5 )) -eq 0 ]; then
        OUT="${OUT}Buzz"
    fi

    if [ -n "$OUT" ]; then
        echo $OUT
    else
        echo $1
    fi

    fizzbash $(( $1 + 1 )) $2
}

fizzbash $1 $2
