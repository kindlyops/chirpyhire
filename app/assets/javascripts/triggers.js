$(document).on("page:change", function() {
  $(".triggers tr[data-link]").click(function() {
      window.location = $(this).data('link');
  });
});
