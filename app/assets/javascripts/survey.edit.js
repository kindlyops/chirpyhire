$(document).on("turbolinks:load", function() {
  if($(".survey.edit").length) {

    var sortableList = $(".survey--questions").get(0);
    var sortable = new Sortable(sortableList, {
      handle: App.Sortable.handle,
      animation: 125,
      onMove: App.Sortable.onMoveUpdateNumber,
      onUpdate: function(e) {
        var $questions = $(e.to);
        _.each($questions.find('.survey--question'), function(question, index) {
          var $question = $(question);
          $question.find(".survey--question-hidden-priority").val(index + 1);
        });
      }
    });
  };
});
