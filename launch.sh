#!/bin/bash

coffee server.coffee &
server=$!

trap "kill $server" KILL

if [ "$1" = "-d" ]; then
  DEBUG="--log-level debug"
fi

titanium build --platform ios --ios-version 7.0 --retina --tall $DEBUG

echo
echo "killing server ($server)"
