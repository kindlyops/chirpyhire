window.App = window.App || {};

$(window).load(function() {
	var delay = 400, 
		className= "tipsy-font",
		options = {className: className, delayIn: delay, delayOut: delay, fade: true}; 
	$(".tipsy-needed").tipsy(options);
	options.gravity = 'w';
	$(".tipsy-needed-w").tipsy(options);
	options.gravity = 'e';
	$(".tipsy-needed-e").tipsy(options);
	options.gravity = 's';
	$(".tipsy-needed-s").tipsy(options);
});
