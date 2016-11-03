// HttpTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Q          = require("q"),
	Util       = require("util"),
	HttpClient = require("http_client"),
	ModalPopup = require("modal_popup");

function HttpTestButton(message, url, login_required) {
	this.url = url;
	this.login_required = login_required;
	this.title = "Try HTTP load (" + message + ")";
	this.button = Ti.UI.createButton({
		title:           this.title,
	});

	this.button.addEventListener("click", Util.bind(this.onClick, this));
}

HttpTestButton.prototype.onClick = function() {
	var promise, getNameModal, url = this.url;

	function validateName(name) {
		if (name === "") { throw "empty name"; }
		return name;
	}

	if (this.login_required) {
		getNameModal = new ModalPopup();
		promise = getNameModal.open().promise()
			.then(validateName)
			// Convert a ModalPopup rejection reason into a HttpClient rejection
			// message so we don't fail the following error handlers. We throw, not
			// return otherwise a return value creates a fulfilled promise not a
			// rejected one.
			.fail(function(reason) {
				throw {status: 0, message: reason};
			})
			// Return a new request url now with a name value
			.then(function(name) { return url + "/" + name; });
		}
		else {
			promise = Q(url);
		}

	promise.then(function(url) { return HttpClient.request('GET', url); })
		.then(function(value) {
			Ti.API.info("[HttpTestButton] HTTP Request completed successfully");
			return value;
		})
		.get("data")
		.get("message")
		.then(notify)
		.fail(function(reason) {
			Ti.API.info("[HttpTestButton] HTTP Request completed unsuccessfully");
			notify("Error: " + reason.status + " - " + reason.message, "Rejected");
		}).done();

	Ti.API.debug("[HttpTestButton] HTTP Request Started");
};

// Helper methods (private)
function notify(message, title) {
	if (title == null) { title = "Notice"; }
	Ti.UI.createAlertDialog({
		message: message,
		title:   title
	}).show();
}

module.exports = HttpTestButton;
/* vim:set ts=2 sw=2 noet fdm=marker: */
