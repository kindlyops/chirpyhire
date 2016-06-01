$(document).on("page:change", function() {
  $(".user").on("click", ".send-message, .cancel-message", function(e) {
    if($("form.new_message").length) {
      e.stopPropagation();
      e.preventDefault();
      $("form.new_message").remove();
      $('.main-content-wrapper').css('height', 'calc(100% - 150px)')
    }
  });

  $(".user").on("change", "select#candidate_status", function(e) {
    var editCandidateForm = $("form.edit_candidate");
    $.ajax({
      url: editCandidateForm.attr("action"),
      data: editCandidateForm.serialize(),
      method: 'PUT',
      dataType: 'html'
    }).done(function(data) {
      var authToken = $(data).find("input[name='authenticity_token']");
      $("form.edit_user input[name='authenticity_token']").replaceWith(authToken);
    });
  });
});
