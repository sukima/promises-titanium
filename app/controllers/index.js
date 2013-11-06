function buildHttpButtons() {
	var i, len, button;

	var httpButtons = [
		{subtitle: "success",          href: "http://localhost:3000/good_json", login: false},
		{subtitle: "parse error",      href: "http://localhost:3000/bad_json",  login: false},
		{subtitle: "not found",        href: "http://localhost:3000/not_found", login: false},
		{subtitle: "needs user input", href: "http://localhost:3000/login",     login: true}
	];

	for (i = 0, len = httpButtons.length; i < len; i++) {
		button = Alloy.createController('http_button', httpButtons[i]);
		$.index.add(button.getView());
	}
}

buildHttpButtons();
$.index.open();
