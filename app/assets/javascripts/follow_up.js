$(function() {
  $(document).on('cocoon:after-insert', '.Bot #follow-ups', function(e, item) {
    var index = $(this).find('.FollowUp').size();
    var settings = $(item).find('#advanced-settings');
    settings.attr('data-index', index);
    var id = $(item).attr('id');
    $(item).attr('id', id.replace('new_follow_ups', index))
    settings.click();
  });

  $('#edit-follow-up-modal #tags').select2({ 
    theme: 'bootstrap', width: '100%'
  });

  $(document).on('show.bs.modal', '#edit-follow-up-modal', function(e) {
    var target = $(e.relatedTarget);
    var followUp = target.closest('.FollowUp');
    var response = followUp.find('.response').val();
    var action = followUp.find('.action').val();
    var questionId = target.data('question-id');
    var index = target.data('index');
    var modal = $(this);
    modal.prop('question_id', questionId);
    modal.prop('follow_up_index', index);
    modal.find('#response').val(response);

    if(action === 'question') {
      var questionId = followUp.find('.next_question_id').val();
      var nextStep = modal.find("#next-step option[data-question-id='" + questionId + "']");
      modal.find('#next-step').val(nextStep.val());
    } else if (action === 'goal') {
      var goalId = followUp.find('.goal_id').val();
      var nextStep = modal.find("#next-step option[data-goal-id='" + goalId + "']");
      modal.find('#next-step').val(nextStep.val());
    }
    
    var tagSelect = modal.find('#tags');
    tagSelect.find('option').removeAttr('selected');
    tagSelect.find('option').removeProp('selected');
    tagSelect.trigger('change');
    var tags = followUp.find('.tag');
    R.forEach(function(tag) {
      var tagId = $(tag).find('.tag_id').val();
      var option = tagSelect.find("option[value='" + tagId + "']");
      option.attr('selected', true);
      option.prop('selected', true);
      tagSelect.trigger('change');
    }.bind(this), tags)
  });

  $(document).on('hide.bs.modal', '#edit-follow-up-modal', function(e) {
    var modal = $(this);
    modal.removeProp('question_id');
    modal.removeProp('follow_up_index');
  });

  $(document).on('submit', '#edit-follow-up-form', function(e) {
    var modal = $('#edit-follow-up-modal');
    var response = modal.find('#response');
    if (response.val()) {
      e.preventDefault();
      var qId = modal.prop('question_id');
      var index = modal.prop('follow_up_index');
      var query = '#question-'+ qId + '-follow-up-' + index;
      var followUp = $('.FollowUp' + query);
      followUp.find('.response').val(response.val());
      followUp.find('.FollowUp--response').text(response.val());
      modal.modal('hide');
    }
  });
});
