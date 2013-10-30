// Root Window - The first window on app launch
/*jshint eqnull:true */
var
	Util              = require("util"),
	TimeoutTestButton = require("timeout_test_button"),
	HttpTestButton    = require("http_test_button"),
	ModalTestButton   = require("modal_test_button");

// Constructor
function RootWin() {
	this.win = Ti.UI.createWindow({
		title:           "Example Applicaiton",
		layout:          "vertical",
		backgroundColor: "white",
		exitOnClose:     true
	});

	buildComponents.call(this);

	this.win.addEventListener("close", Util.bind(this.onDestroy, this));
}

// onDestroy event handler
RootWin.prototype.onDestroy = function() {
	this.timeoutTestButton = null;
	this.modalTestButton = null;
	this.httpButtons = null;
	this.win = null;
};

// open()
RootWin.prototype.open = function() {
	this.win.open();
	return this;
};

// close()
RootWin.prototype.close = function() {
	this.win.close();
	return this;
};

// Helper methods (private)
function buildComponents() {
	var i, len;

	this.timeoutTestButton = new TimeoutTestButton();
	this.modalTestButton   = new ModalTestButton();
	this.httpButtons = [
		new HttpTestButton("success", "http://localhost:3000/arujex/1/js", true),
		new HttpTestButton("parse error", "http://localhost:3000/ikupag/1/js"),
		new HttpTestButton("not found", "http://localhost:3000/not_found")
	];

	this.win.add(this.timeoutTestButton.button);
	this.win.add(this.modalTestButton.button);
	for (i = 0, len = this.httpButtons.length; i < len; i++) {
		this.win.add(this.httpButtons[i].button);
	}
}

module.exports = RootWin;
/* vim:set ts=2 sw=2 noet fdm=marker: */
