window.App = window.App || {};

$(window).load(function() {
	$(".tipsy-needed").tipsy();
	$(".tipsy-needed-w").tipsy({gravity: 'w'});
	$(".tipsy-needed-e").tipsy({gravity: 'e'});
	$(".tipsy-needed-s").tipsy({gravity: 's'});
})