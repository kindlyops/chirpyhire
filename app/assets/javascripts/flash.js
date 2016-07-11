$(document).on("turbolinks:load", function() {
  setTimeout(function() {
    $('.flash-alert, .flash-notice').slideUp();
  }, 3000);
});
