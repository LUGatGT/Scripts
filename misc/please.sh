#!/bin/bash

# source this file in your bashrc for great results

# works under arch. Im not sure which dependencies you need, if you need any (besides sudo obviously)

# plz can i has stdio
alias please='echo "ok: `fc -ln -1`" && sudo `fc -ln -1`'

# Here is a quiter alternative if people prefer, this at least works under zsh. - MiningMarsh
# alias please='sudo $(fc -ln -1)'
