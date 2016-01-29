#!/bin/bash

###########
# Aliases #
###########
alias please='sudo $(fc -ln -1)'
alias http='python3 -m http.server'
alias again='until $(fc -ln -1); do :; done'
alias clbin="curl -F 'clbin=<-' https://clbin.com"

#############
# Functions #
#############
function targz() {
    tar -zcvf "${1}.tar.gz" "${1}"
}

function watch() {
    while :; do
        inotifywait -e close_write "$1"
        RUN=$(echo $@ | cut -d " " -f2-)
        echo "Running $RUN..."
        eval "$RUN"
    done
}
