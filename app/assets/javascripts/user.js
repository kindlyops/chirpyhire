$(document).on("page:change", function() {
  $(".user").on("click", ".send-message, .cancel-message", function(e) {
    if($("form.new_message").length) {
      e.stopPropagation();
      e.preventDefault();
      $("form.new_message").remove();
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

  var $timeline_block = $('.timeline-block');
  $timeline_block.each(function() {
      if ($(this).offset().top > $(window).scrollTop() + $(window).height() * 0.75) {
          $(this).find('.timeline-point, .timeline-content').addClass('is-hidden');
      }
  });
  $(window).on('scroll', function() {
      $timeline_block.each(function() {
          if ($(this).offset().top <= $(window).scrollTop() + $(window).height() * 0.75 && $(this).find('.timeline-point').hasClass('is-hidden')) {
              $(this).find('.timeline-point, .timeline-content').removeClass('is-hidden').addClass('bounce-in');
          }
      });
  });
});
