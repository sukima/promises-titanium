global.Ti = global.Titanium = require("mockti")
global.Titanium.Platform.displayCaps.getDensity = -> "medium"
global.Titanium.Filesystem.separator = "/"

orig_proxyquire = require("proxyquire")

exports.proxyquire = (module, mocks...) ->
  module = "../Resources/#{module}"
  if mocks.length is 0
    require module
  else
    orig_proxyquire module, mocks...
