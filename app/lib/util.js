// Util - Util methods
/*jshint eqnull:true */

var slice = Array.prototype.slice;

exports.bind = function(fn, context) {
	return function() {
		return fn.apply(context, slice.call(arguments));
	};
};

exports.partial = function(fn) {
	var args = slice.call(arguments, 1);
	return function() {
		return fn.apply(this, args.concat(slice.call(arguments)));
	};
};

/* vim:set ts=2 sw=2 noet fdm=marker: */
