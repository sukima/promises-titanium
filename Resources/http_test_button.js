// HttpTestButton - A button for testing a timeout with promises
/*jshint eqnull:true */
var
	Util       = require("util"),
	HttpClient = require("http_client");

function HttpTestButton(message, url) {
	this.url = url;
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
	HttpClient.request(this.url)
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
