$(document).on("page:change", function() {
  $(".rules tr[data-link]").click(function() {
      window.location = $(this).data('link');
  });
});
