$(document).on("page:change", function() {
  $(".candidate").on("click", ".send-message, .cancel-message", function(e) {
    if($("form.new_message").length) {
      e.stopPropagation();
      e.preventDefault();
      $("form.new_message").remove();
    }
  });
});
