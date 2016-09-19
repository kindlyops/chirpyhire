window.App = window.App || {};

// Enable tipsy
$(window).load(function() {
	var delay = 400, 
		className= "tipsy-font",
		options = {className: className, delayIn: delay, delayOut: delay / 2, fade: true}; 
	$(".tipsy-needed").tipsy(options);
	options.gravity = 'w';
	$(".tipsy-needed-w").tipsy(options);
	options.gravity = 'e';
	$(".tipsy-needed-e").tipsy(options);
	options.gravity = 's';
	$(".tipsy-needed-s").tipsy(options);
});

// Block disabled links
$(document).on("turbolinks:load", function() {
	$(document).on("click", "a.disabled", function(e) { 
		e.stopImmediatePropagation();
		return false;
	});
});
