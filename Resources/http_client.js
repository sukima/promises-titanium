// HttpClient - A simple promises enable HTTP client
/*jshint eqnull:true */
var Q = require("q");

exports.request = function(method, url, headers, formdata) {
	var defer, tiHttpClient;

	defer = Q.defer();

	tiHttpClient = Ti.Network.createHTTPClient({
		onload: function() {
			var parsedData, error;
			if (this.status >= 200 && this.status < 300) {
				try { parsedData = JSON.parse(this.responseText); }
				catch (e) { error = e; }
			}
			else {
				error = "Bad HTTP Code";
			}
			if (error) {
				defer.reject({
					status:  this.status,
					message: error
				});
			}
			else {
				defer.resolve({
					status:  this.status,
					data: parsedData
				});
			}
		},
		onerror: function() {
			defer.reject({
				status:  this.status,
				message: this.responseText
			});
		},
		onsendstream: function(e) {
			defer.notify(e);
		}
	});

	tiHttpClient.open(method, url, true);
	if (typeof headers !== 'undefined') {
		for (header in headers) {
			tiHttpClient.setRequestHeader(header, headers[header]);
		}
	}
	if (typeof formdata !== 'undefined') {
		tiHttpClient.send(formdata);
	} else {
		tiHttpClient.send();
	}

	return defer.promise;
};

/* vim:set ts=2 sw=2 noet fdm=marker: */
