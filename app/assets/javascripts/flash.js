$(document).on("turbolinks:load", function() {
  setTimeout(function() {
    $('.flash-alert, .flash-success, .flash-error, .flash-notice').slideUp();
  }, 3000);
});
