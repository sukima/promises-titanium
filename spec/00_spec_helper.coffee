# Load up the Titanum API from mockti
global.Ti = global.Titanium = require("mockti")
# Some defaults that mockti is missing
global.Titanium.Platform.displayCaps.getDensity = -> "medium"
global.Titanium.Filesystem.separator = "/"
global.Titanium.UI.iOS.createNavigationWindow = global.Titanium.UI.createWindow

# Store a reference to the original proxyquire function
orig_proxyquire = require("proxyquire")

# Tests are run in Node which offers a global "util" module. Since while
# testing we are not running in the Titanium environment which would read the
# util.js file in the Resources directory, we have to force node to load the
# correct one.
Util = require("../Resources/util")
# Since we want to overwite the node "util" module we do not want it merge
# the node module with our own. @noCallThru prevents that.
Util["@noCallThru"] = true

# Override the proxyquire for our own logic
# export it so it is available inside all describe and it blocks
exports.proxyquire = (module, mocks={}) ->
  # Add the correct Util module to the mocks
  mocks["util"] = Util
  module = "../Resources/#{module}"
  orig_proxyquire module, mocks
