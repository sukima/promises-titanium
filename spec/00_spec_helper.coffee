# Load up the Titanum API from mockti
global.Ti = global.Titanium = require("mockti")
# Some defaults that mockti is missing
global.Titanium.Platform.displayCaps.getDensity = -> "medium"
global.Titanium.Filesystem.separator = "/"
global.Titanium.UI.iOS.createNavigationWindow = global.Titanium.UI.createWindow

# Store a reference to the original proxyquire function
orig_proxyquire = require("proxyquire")

# Override the proxyquire for our own logic
# export it so it is available inside all describe and it blocks
exports.proxyquire = (module, mocks={}) ->
  if has_alloy
    mocks["alloy"] = Alloy
    mocks["alloy/controllers/BaseController"] = BaseController
  module = "../Resources/#{module}"
  orig_proxyquire module, mocks

# Alloy Constants and Globals
has_alloy = do ->
  {resolve} = require("path")
  {existsSync} = require("fs")
  existsSync resolve(__dirname, "../Resources/alloy")

if has_alloy
  Alloy = require("../Resources/alloy")
  Alloy["@noCallThru"] = true

  BaseController = orig_proxyquire(
    "../Resources/alloy/controllers/BaseController", "alloy": Alloy
  )
  BaseController["@noCallThru"] = true
