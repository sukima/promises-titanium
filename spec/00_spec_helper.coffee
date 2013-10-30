global.Ti = global.Titanium = require("mockti")
global.Titanium.Platform.displayCaps.getDensity = -> "medium"
global.Titanium.Filesystem.separator = "/"

orig_proxyquire = require("proxyquire")

exports.proxyquire = (path, mocks...) ->
	orig_proxyquire "../Resources/#{module}", mocks...
