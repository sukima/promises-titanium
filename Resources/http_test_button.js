// HttpTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Util       = require("util"),
	HttpClient = require("http_client"),
	ModalPopup = require("modal_popup");

function HttpTestButton(message, url, login_required) {
	this.url = url;
	this.login_required = login_required;
	this.title = "Try HTTP load (" + message + ")";
	this.button = Ti.UI.createButton({
		title:           this.title,
		backgroundColor: "grey",
		width:           "80%",
		height:          40,
		top:             20,
		borderRadius:    6,
		borderWidth:     2
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
			.fail(function(reason) {
				// Convert a ModalPopup rejection reason into a HttpClient rejection
				// message so we don't fail the following error handlers. We throw, not
				// return otherwise a return value creates a fulfilled promise not a
				// rejected one.
				throw {status: 0, message: reason};
			})
			.then(function(name) {
				return HttpClient.request(url + "/" + name);
			});
	}
	else {
		promise = HttpClient.request(url);
	}

	promise.then(function(value) {
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
