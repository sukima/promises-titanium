var ModalPopup = require("modal_popup");
var HttpClient = require("http_client");
var Q          = require("q");
var options    = arguments[0] || {};

$.button.title = "HTTP Test (" + options.subtitle + ")";
$.button.addEventListener("click", onClick);

options.login = (options.login === "true");

function onClick() {
	var promise, getNameModal, url = options.href;

	function validateName(name) {
		if (name === "") { throw "empty name"; }
		return name;
	}

	if (options.login) {
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

	promise.then(function(url) { return HttpClient.request(url); })
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
}

// Helper methods (private)
function notify(message, title) {
	/*jshint eqnull:true */
	if (title == null) { title = "Notice"; }
	Ti.UI.createAlertDialog({
		message: message,
		title:   title
	}).show();
}
