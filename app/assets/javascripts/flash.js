$(document).on("turbolinks:load", function() {
  setTimeout(function() {
    $('.alert, .notice').slideUp();
  }, 4000);
});
