#!/bin/bash

export TERM=xterm-256color

alias ec='emacsclient -t'
alias fsd='screen -dRR'
alias findf='find . -type f'
alias dps='docker ps'
alias dpsa='docker ps -a'

drm() {
    docker ps -a --format "{{.ID}}" | xargs -r docker stop | xargs -r docker rm
}

hbase_shell() {
    docker exec -it hbase hbase shell
}

add_container() {
    local container=${1:?Usage: $FUNCNAME container service}

    host_entry=$(docker exec $container cat /etc/hosts |
                     egrep -v '(localhost|ip6)' | tail -n1)

    if [[ -n "$host_entry" ]]; then

        temp_file=$(mktemp)
        (
            cat /etc/hosts | fgrep -v $container
            echo ${host_entry} $container \# added by $FUNCNAME.
        ) > $temp_file

        sudo mv ${temp_file} /etc/hosts
        sudo chmod 644 /etc/hosts
    else
        (
            echo could not get host name for \'$container\' from hosts file:
            docker exec $container cat /etc/hosts
        ) >&2
    fi

}

add_containers() {
    docker ps --format '{{.Names}}' | while read container; do
        add_container $container
    done
}
