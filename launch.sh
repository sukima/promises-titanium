#!/bin/bash

APP_ID=org.tritarget.wnlmobile.app
# Must be capitalized!
APP_NAME=WNLMobile

PATH=node_modules/.bin:$PATH
while test $# -gt 0; do
    case "$1" in
        -i)
            install="yes"
            ;;
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

if [ "$install" = "yes" ]; then
  exec titanium build -p ios --ios-version 7.0 -T device
elif [ "$android" = "yes" ]; then
  titanium build --platform android --build-only --avd-id 1 $DEBUG && \
  adb uninstall $APP_ID
  adb install build/android/bin/app.apk && \
  adb shell am start ${APP_ID}/.${APP_NAME}Activity
else
  exec titanium build --platform ios --ios-version 7.0 --retina --tall $DEBUG $remote
fi
