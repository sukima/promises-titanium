#!/bin/bash

coffee server.coffee &
server=$!

trap "kill $server" KILL

titanium build --platform ios --ios-version 7.0 --retina --tall --log-level debug

echo
echo "killing server ($server)"
