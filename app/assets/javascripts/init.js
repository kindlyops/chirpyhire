window.App = window.App || {};

// Enable tipsy
$(document).on("turbolinks:load", function() {
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

// Turbolinks scroll to top issues
// https://github.com/turbolinks/turbolinks-classic/issues/66
$(document).on("turbolinks:before-visit", function() {
  window.prevPageYOffset = window.pageYOffset;
  window.prevPageXOffset = window.pageXOffset;
});
$(document).on("turbolinks:render", function() {
  if ($(".fix-turbolinks-scroll").length > 0) {
    window.scrollTo(window.prevPageXOffset, window.prevPageYOffset);
  }
});
