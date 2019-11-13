#!/bin/bash

export TERM=xterm-256color

alias ec='emacsclient -t'
alias fsd='screen -dRR'

drm() {
    docker ps -a --format "{{.ID}}" | xargs -r docker stop | xargs -r docker rm
}
