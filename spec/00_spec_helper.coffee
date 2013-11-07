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
exports.proxyquire = proxyquire = (module, mocks={}) ->
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
  exports.Alloy = Alloy = require("../Resources/alloy")
  Alloy["@noCallThru"] = true

  BaseController = orig_proxyquire(
    "../Resources/alloy/controllers/BaseController", "alloy": Alloy
  )
  BaseController["@noCallThru"] = true

# Hides console output from program
# Keep references in case you need to test against values (probably a bad idea)
exports.LOGS = LOGS = []
global.Titanium.API.error = (val) -> LOGS.push {level: "ERROR", message: val}
global.Titanium.API.info  = (val) -> LOGS.push {level: "INFO", message: val}
global.Titanium.API.debug = (val) -> LOGS.push {level: "DEBUG", message: val}
global.Titanium.API.warn  = (val) -> LOGS.push {level: "WARN", message: val}
exports.dumpLogs = ->
  console.log "[#{level}] #{message}" for {level, message} in LOGS
