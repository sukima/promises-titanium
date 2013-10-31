// ModalTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Util       = require("util"),
	ModalPopup = require("modal_popup");

function ModalTestButton() {
	this.button = Ti.UI.createButton({
		title:           "Modal Window Test",
		backgroundColor: "grey",
		width:           "80%",
		height:          40,
		top:             20,
		borderRadius:    6,
		borderWidth:     2
	});

	this.button.addEventListener("click", Util.bind(this.onClick, this));
}

ModalTestButton.prototype.onClick = function() {
	var _this = this, popup, promise;

	popup = new ModalPopup();
	promise = popup.open().promise();

	Ti.API.debug("[ModalTestButton] Modal Popup opened");

	promise.then(function(name) {
		Ti.API.info("[ModalTestButton] User inputed name as '" + name + "'");
		if (name === "") { throw "empty name"; }
		_this.button.setTitle("Hello " + name + "!");
	})
	.fail(function(reason) {
		Ti.API.info("[ModalTestButton] Modal Popup promise rejected, " + reason);
		_this.button.setTitle("I don't know you (" + reason + ")");
	}).done();
};

module.exports = ModalTestButton;
/* vim:set ts=2 sw=2 noet fdm=marker: */
