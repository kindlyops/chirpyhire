$(document).on("page:change", function() {
  $(".candidate").on("click", ".send-message, .cancel-message", function(e) {
    if($("form.new_message").length) {
      e.stopPropagation();
      e.preventDefault();
      $("form.new_message").remove();
    }
  });

  $(".candidate").on("change", "select#candidate_status", function(e) {
    var editCandidateForm = $("form.edit_candidate");
    $.ajax({
      url: editCandidateForm.attr("action"),
      data: editCandidateForm.serialize(),
      method: 'PUT',
      dataType: 'html'
    }).done(function(data) {
      var authToken = $(data).find("input[name='authenticity_token']");
      $("form.edit_candidate input[name='authenticity_token']").replaceWith(authToken);
    });
  });

  $(".candidate").on("change", "select#template", function(e) {
    if (e.currentTarget.value === "") { return; }

    $.get("/templates/" + e.currentTarget.value + "/preview?user_id=<%= @recipient.id %>", function(data) {
      $("textarea#message_body").val(data);
    }, "text");
  });
});
