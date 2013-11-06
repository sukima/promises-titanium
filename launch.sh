#!/bin/bash

APP_ID=com.tritarget.promises.example.app
# Must be capitalized!
APP_NAME=PromisesExample

PATH=node_modules/.bin:$PATH
while test $# -gt 0; do
    case "$1" in
        -d)
            DEBUG="--log-level debug"
            ;;
        -r)
            # Support ti-inspector
            remote="--debug-host localhost:8999"
            ;;
        -a)
            android="yes"
            ;;
    esac

    shift
done

if [ "$android" = "yes" ]; then
  titanium build --platform android --build-only --avd-id 1 $DEBUG && \
  adb uninstall $APP_ID
  adb install build/android/bin/app.apk && \
  adb shell am start ${APP_ID}/.${APP_NAME}Activity
else
  exec titanium build --platform ios --ios-version 7.0 --retina --tall $DEBUG $remote
fi
