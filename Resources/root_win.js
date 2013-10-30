// Root Window - The first window on app launch
/*jshint eqnull:true */
var
	Util                 = require("util"),
	TimeoutTestButton = require("timeout_test_button"),
	// HttpTestButton    = require("http_test_button"),
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
	this.timeoutTestButton = new TimeoutTestButton();
	// this.httpTestButton    = new HttpTestButton();
	this.modalTestButton   = new ModalTestButton();

	this.win.add(this.timeoutTestButton.button);
	// this.win.add(this.httpTestButton.button);
	this.win.add(this.modalTestButton.button);
}

module.exports = RootWin;
/* vim:set ts=2 sw=2 noet fdm=marker: */
