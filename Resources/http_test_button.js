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
		.fail(function(reason) {
			notify("Error: " + reason.status + " - " + reason.message);
		})
		.get("data")
		.get("message")
		.then(notify);
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
