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
		statusBarStyle:  Ti.UI.iPhone.StatusBar.GRAY,
		backgroundColor: "gray"
	});
	this.navWin = Ti.UI.iOS.createNavigationWindow({
		window: this.win,
		modal:  true
	});
	this.label = Ti.UI.createLabel({
		text:  "Dear kind user, what is your name?",
		width: "90%",
		top:   30
	});
	this.name_input = Ti.UI.createTextField({
		width:           "90%",
		height:          40,
		backgroundColor: "white",
		borderWidth:     2,
		top:             70,
		borderStyle:     Titanium.UI.INPUT_BORDERSTYLE_BEZEL,
		hintText:        "This space intentionally left blank",
		returnKeyType:   Ti.UI.RETURNKEY_DONE
	});
	this.submit_button = Ti.UI.createButton({
		systemButton: Ti.UI.iPhone.SystemButton.DONE
	});
	this.cancel_button = Ti.UI.createButton({
		systemButton: Ti.UI.iPhone.SystemButton.CANCEL
	});

	onClickBind = Util.bind(this.onButtonClick, this);

	this.navWin.addEventListener("open", Util.bind(this.onOpen, this));
	this.navWin.addEventListener("close", Util.bind(this.onDestroy, this));
	this.name_input.addEventListener("return", Util.partial(onClickBind, "submit"));
	this.submit_button.addEventListener("click", Util.partial(onClickBind, "submit"));
	this.cancel_button.addEventListener("click", Util.partial(onClickBind, "cancel"));

	this.win.add(this.label);
	this.win.add(this.name_input);
	this.win.setLeftNavButton(this.cancel_button);
	this.win.setRightNavButton(this.submit_button);
}

ModalPopup.prototype.onOpen = function() {
	this.name_input.focus();
};

ModalPopup.prototype.onDestroy = function() {
	this.cancel_button = null;
	this.submit_button = null;
	this.name_input = null;
	this.label = null;
	this.navWin = null;
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
	this.navWin.open({modal: true});
	return this;
};

ModalPopup.prototype.close = function() {
	this.navWin.close();
	return this;
};

module.exports = ModalPopup;
/* vim:set ts=2 sw=2 noet fdm=marker: */
