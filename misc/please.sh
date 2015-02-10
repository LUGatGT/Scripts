
# source this file in your zshrc for great results

# works under arch, under zsh. Im not sure which dependencies you need, if you need any (besides sudo obviously)

# plz can i has stdio
alias sudo='sudo '
alias please='print -s "sudo $(fc -ln -1)" && echo "ok: $(fc -ln -1)" && eval sudo $(fc -ln -1)'
alias plz='please '
zshaddhistory() {
    [[ ! (("$1" == *please*) || ("$1" == *plz*)) ]]
}

# Here is a quiter alternative if people prefer, this at least works under zsh. - MiningMarsh
# alias please='sudo $(fc -ln -1)'
