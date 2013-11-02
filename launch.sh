#!/bin/bash

coffee server.coffee &
server=$!

trap "kill $server" KILL

while test $# -gt 0; do
    case "$1" in
        -d)
            DEBUG="--log-level debug"
            ;;
        -r)
            # Support ti-inspector
            remote="--debug-host localhost:8999"
            ;;
    esac

    shift
done

titanium build --platform ios --ios-version 7.0 --retina --tall $DEBUG $remote

echo
echo "killing server ($server)"
