$.button.addEventListener("click", onClick);

function onClick() {
	var popup, promise;

	popup = Alloy.createController("modal_popup");
	promise = popup.promise();
	popup.getView().open();

	Ti.API.debug("[ModalTestButton] Modal Popup opened");

	promise.then(function(name) {
		Ti.API.info("[ModalTestButton] User inputed name as '" + name + "'");
		if (name === "") { throw "empty name"; }
		$.button.setTitle("Hello " + name + "!");
	})
	.fail(function(reason) {
		Ti.API.info("[ModalTestButton] Modal Popup promise rejected, " + reason);
		$.button.setTitle("I don't know you (" + reason + ")");
	}).done();
}
