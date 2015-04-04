// TimeoutTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Util            = require("util"),
	TimeoutPromiser = require("timeout_promiser");

function TimeoutTestButton() {
	this.button = Ti.UI.createButton({
		title:           "Timeout Test",
	});

	this.button.addEventListener("click", Util.bind(this.onClick, this));
}

// Event methods
TimeoutTestButton.prototype.onClick = function() {
	var _this = this, promise;

	this.button.setEnabled(false);
	this.button.setTitle("And... Go!");

	promise = TimeoutPromiser.run();

	Ti.API.debug("[TimeoutTestButton] TimeoutPromiser return a promise");

	promise.then(function(value) {
		Ti.API.info("[TimeoutTestButton] Promise was fulfilled");
		_this.button.setTitle("" + value + " (try again)");
	})
	.fail(function(reason) {
		Ti.API.info("[TimeoutTestButton] Promise was rejected");
		_this.button.setTitle("Oh Nos! " + reason);
	})
	.progress(function(count) {
		_this.button.setTitle("Petting kittens... " + count);
	})
	.fin(function() {
		_this.button.setEnabled(true);
	}).done();
};

module.exports = TimeoutTestButton;
/* vim:set ts=2 sw=2 noet fdm=marker: */
