// TimeoutTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Q    = require("q"),
	Util = require("util");

function TimeoutTestButton() {
	this.button = Ti.UI.createButton({
		title:           "Timeout Test",
		backgroundColor: "grey",
		width:           "80%",
		height:          40,
		top:             20,
		borderRadius:    6,
		borderWidth:     2
	});

	this.button.addEventListener("click", Util.bind(this.onClick, this));
}

// Event methods
TimeoutTestButton.prototype.onClick = function() {
	var _this = this, promise;

	this.button.setEnabled(false);
	this.button.setTitle("And... Go!");

	promise = runTimeout();

	promise.then(function(value) {
		_this.button.setTitle("" + value + " (try again)");
	});

	promise.fail(function(reason) {
		_this.button.setTitle("Oh Nos! " + reason);
	});

	promise.progress(function(count) {
		_this.button.setTitle("Petting kittens... " + count);
	});

	promise.fin(function() {
		_this.button.setEnabled(true);
	});
};

// Helper methods (private)
function runTimeout() {
	var
		defer        = Q.defer(),
		timeout      = 1000,
		currentCount = 11;

	function update() {
		currentCount--;
		if (currentCount > 0) {
			if (currentCount < 6 && randomFail()) {
				defer.reject("Random error");
			}
			else {
				defer.notify(currentCount);
				setTimeout(update, timeout);
			}
		}
		else {
			defer.resolve("Yeah it finished!");
		}
	}

	update();

	return defer.promise;
}

function randomFail() {
	return (Math.random() > 0.8);
}

module.exports = TimeoutTestButton;
/* vim:set ts=2 sw=2 noet fdm=marker: */
