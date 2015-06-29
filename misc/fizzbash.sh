#!/bin/bash

# Takes a range (a, b] and prints all the numbers in this range
# Does FizzBuzz!

function fizzbackend() {
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
}

function fizzbash() {
    if [ $1 -eq $2 ]; then
        return 0
    fi

	fizzbackend "$1"
    fizzbash $(( $1 + 1 )) $2
}

fizzbash $1 $2

# I don't think bash has TCO, so here is a non-recursive solution.
function fizzbuzz() {
	START="$1"
	END="$2"
	for ((i=START; i<=END; ++i)); do
		fizzbackend "$i"
	done

	return
}

fizzbuzz $1 $2
