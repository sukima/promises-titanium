// ModalTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Q          = require("q"),
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

	promise.then(function(name) {
		_this.button.setTitle("Hello " + name + "!");
	});
	promise.fail(function(reason) {
		_this.button.setTitle("I don't know you (" + reason + ")");
	});
};

module.exports = ModalTestButton;
/* vim:set ts=2 sw=2 noet fdm=marker: */
