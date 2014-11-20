#!/bin/bash
SAVED_FILE="quote-"$(echo "$1" | tr '/' '_' | tr '.' '_')
# OWN_FILE="../../service/ownership/gettingRandomQuote"

# if [ $(cat "$OWN_FILE") -eq 1 ]; then
# 	echo "One instance is already running, close this first."
# 	exit 2
# else
	if [ ! -f "$1" ]; then
		echo "No list of links given. Exiting..."
		exit 1
	fi

	# echo 1 > "$OWN_FILE"

	getQuote() {

		LINKS=$(cat "$1" | grep -v -e '^[[:space:]]*$' -e '^[[:space:]]*#')
		COUNT=$(echo "$LINKS" | wc -l)
		PICK=$((($RANDOM % $COUNT) + 1))
		QUOTE=$(echo "$LINKS" | sed -n ${PICK}p)
		#
		wget -O "$SAVED_FILE" "$QUOTE"
	}

	playAndDelete() {
		play "$1"
		rm   "$1"
	}

	if [ -s "$SAVED_FILE" ]; then
		playAndDelete "$SAVED_FILE"
	else
		getQuote "$1"
		playAndDelete "$SAVED_FILE"
	fi

	getQuote "$1"

	# echo 0 > "$OWN_FILE"
# fi
