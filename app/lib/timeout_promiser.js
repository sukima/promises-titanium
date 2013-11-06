// TimeoutPromiser - A simple setTimeout based countdown module
/*jshint eqnull:true */
var
	Q = require("q"),
	TimeoutPromiser = {};

TimeoutPromiser.timeout = 1000;
TimeoutPromiser.steps   = 10;

TimeoutPromiser.run = function() {
	var
		defer        = Q.defer(),
		currentCount = TimeoutPromiser.steps + 1;

	function update() {
		currentCount--;
		if (currentCount > 0) {
			if (currentCount < 6 && TimeoutPromiser.randomFail()) {
				defer.reject("Random error");
			}
			else {
				defer.notify(currentCount);
				setTimeout(update, TimeoutPromiser.timeout);
			}
		}
		else {
			defer.resolve("Yeah it finished!");
		}
	}

	update();

	return defer.promise;
};

TimeoutPromiser.randomFail = function() {
	return (Math.random() > 0.8);
};

module.exports = TimeoutPromiser;
/* vim:set ts=2 sw=2 noet fdm=marker: */
