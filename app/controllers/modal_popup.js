var Q = require("q");

$.defer = Q.defer();

$.getView().addEventListener("open", onOpen);
$.submit_button.addEventListener("click", _.partial(onClick, "submit"));
$.cancel_button.addEventListener("click", _.partial(onClick, "cancel"));
$.name_input.addEventListener("return",   _.partial(onClick, "submit"));

exports.promise = function() {
	return $.defer.promise;
};

function onOpen() {
	$.name_input.focus();
}

function onClick(action) {
	switch (action) {
		case "submit":
			$.defer.resolve($.name_input.getValue());
			break;
		case "cancel":
			$.defer.reject("cancled");
			break;
		default:
			throw "Application logic fell into the void with action: " + action;
	}
	$.getView().close();
}
