var TimeoutPromiser = require("timeout_promiser");

$.timeout_button.addEventListener("click", onClick);

function onClick() {
	var promise;

	$.timeout_button.setEnabled(false);
	$.timeout_button.setTitle("And... Go!");

	promise = TimeoutPromiser.run();

	Ti.API.debug("[TimeoutTestButton] TimeoutPromiser return a promise");

	promise.then(function(value) {
		Ti.API.info("[TimeoutTestButton] Promise was fulfilled");
		$.timeout_button.setTitle("" + value + " (try again)");
	})
	.fail(function(reason) {
		Ti.API.info("[TimeoutTestButton] Promise was rejected");
		$.timeout_button.setTitle("Oh Nos! " + reason);
	})
	.progress(function(count) {
		$.timeout_button.setTitle("Petting kittens... " + count);
	})
	.fin(function() {
		$.timeout_button.setEnabled(true);
	}).done();
}
