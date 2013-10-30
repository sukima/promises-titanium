// TimeoutPromiser - A simple setTimeout based countdown module
/*jshint eqnull:true */
var Q = require("q");

exports.run = function() {
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
};

function randomFail() {
	return (Math.random() > 0.8);
}

/* vim:set ts=2 sw=2 noet fdm=marker: */
