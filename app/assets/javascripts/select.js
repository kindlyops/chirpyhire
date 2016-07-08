$(document).on("turbolinks:load", function() {
  $("select").select2();

  $(".content").on("change", "select#template", function(e) {
    if (e.currentTarget.value === "") { return; }
    var userId = $(e.currentTarget).data("user-id");
    $.get("/templates/" + e.currentTarget.value + "/preview?user_id=" + userId, function(data) {
      $("textarea#body").val(data);
    }, "text");
  });
});
