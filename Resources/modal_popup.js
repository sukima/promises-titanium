// ModalPopup - A modal window which facilitates a promise for interaction.
/*jshint eqnull:true */
var
	Q    = require("q"),
	Util = require("util");

function ModalPopup() {
	var onClickBind;
	this.defer = Q.defer();
	this.win = Ti.UI.createWindow({
		title:           "Can haz name?",
		barColor:        "white",
		translucent:     false,
		backgroundColor: "black",
		layout:          "vertical"
	});
	this.label = Ti.UI.createLabel({
		text:  "Dear kind user, what is your name?",
	});
	this.name_input = Ti.UI.createTextField({
		width:           "90%",
		backgroundColor: "white",
		color:           "black"
	});
	this.buttons_view = Ti.UI.createView({
		width: Ti.UI.SIZE,  
		height: Ti.UI.SIZE 
	});
	this.buttons_center = Ti.UI.createView({
		layout: 'horizontal', 
		width: Ti.UI.SIZE,  
		height: Ti.UI.SIZE 
	});
	this.submit_button = Ti.UI.createButton({
		title: 'submit'
	});
	this.cancel_button = Ti.UI.createButton({
		title: 'cancel'
	});

	onClickBind = Util.bind(this.onButtonClick, this);

	this.win.addEventListener("open", Util.bind(this.onOpen, this));
	this.win.addEventListener("close", Util.bind(this.onDestroy, this));
	this.name_input.addEventListener("return", Util.partial(onClickBind, "submit"));
	this.submit_button.addEventListener("click", Util.partial(onClickBind, "submit"));
	this.cancel_button.addEventListener("click", Util.partial(onClickBind, "cancel"));

	this.win.add(this.label);
	this.win.add(this.name_input);
	this.buttons_center.add(this.cancel_button);
	this.buttons_center.add(this.submit_button);
	this.buttons_view.add(this.buttons_center);
	this.win.add(this.buttons_view);
}

ModalPopup.prototype.onOpen = function() {
	this.name_input.focus();
};

ModalPopup.prototype.onDestroy = function() {
	this.cancel_button = null;
	this.submit_button = null;
	this.name_input = null;
	this.label = null;
	this.win = null;
};

ModalPopup.prototype.onButtonClick = function(action) {
	switch (action) {
		case "submit":
			this.defer.resolve(this.name_input.getValue());
			break;
		case "cancel":
			this.defer.reject("cancled");
			break;
		default:
			throw "Application logic fell into the void with action: " + action;
	}
	this.close();
};

ModalPopup.prototype.promise = function() {
	return this.defer.promise;
};

ModalPopup.prototype.open = function() {
	this.win.open();
	return this;
};

ModalPopup.prototype.close = function() {
	this.win.close();
	return this;
};

module.exports = ModalPopup;
/* vim:set ts=2 sw=2 noet fdm=marker: */
