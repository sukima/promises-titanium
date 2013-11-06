var TimeoutPromiser = require("timeout_promiser");

$.button.addEventListener("click", onClick);

function onClick() {
	var promise;

	$.button.setEnabled(false);
	$.button.setTitle("And... Go!");

	promise = TimeoutPromiser.run();

	Ti.API.debug("[TimeoutTestButton] TimeoutPromiser return a promise");

	promise.then(function(value) {
		Ti.API.info("[TimeoutTestButton] Promise was fulfilled");
		$.button.setTitle("" + value + " (try again)");
	})
	.fail(function(reason) {
		Ti.API.info("[TimeoutTestButton] Promise was rejected");
		$.button.setTitle("Oh Nos! " + reason);
	})
	.progress(function(count) {
		$.button.setTitle("Petting kittens... " + count);
	})
	.fin(function() {
		$.button.setEnabled(true);
	}).done();
}
