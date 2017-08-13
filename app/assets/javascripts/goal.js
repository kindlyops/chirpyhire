$(function() {
  calculateGoalRanks = function(goal) {
    var eachWithIndex = R.addIndex(R.forEach)

    eachWithIndex(function(goal, i) {
      var rank = i + 1;
      var $goal = $(goal);
      $goal.find('.goal-rank').val(rank);
      $goal.find('.bot-card--label').text('Goal ' + rank + ':');
    }, goal);
  }

  $('#goals').on('cocoon:after-remove', function(e, item) {
    $(item).addClass('removed');
    calculateGoalRanks($('#goals .nested-fields:not(.removed)'));
  });
});
