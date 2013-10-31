# Promises Titanium Example [![Build Status](https://travis-ci.org/sukima/promises-titanium.png?branch=master)](https://travis-ci.org/sukima/promises-titanium)

An example on using promises in a Titanium application.

## Getting Started

First make sure you have a working titanium environment. NPM will install
titanium as a dependency however, it still needs to install the SDK manually.
It is recommended you install titanium globally first.

    $ npm install -g titanium
    $ titanium sdk install 3.1.3.GA

Once ready run the following in the projects working directory.

    $ npm install .
    $ npm start             # start server and compile app OR
    $ npm run-script debug  # for verbose debug output

This will spawn a small express server for demo uses and then will build the
application and spawn it in the iOS simulator.
