$(function() {
  $('.collapse.bot-action').on('shown.bs.collapse', function () {
    var autoResize = $(this).find('textarea[data-autoresize]');
    autoResize.trigger('input');
  });

  if($('.edit_bot').length !== 0) {
    $('.edit_bot #questions.sortable').sortable({
      axis: 'y',
      scroll: 'true',
      handle: '.question-handle',
      update: function() {
        var $this = $(this);
        _.each($this.find('.question'), function(question, index) {
          $(question).find('.rank').text(index + 1);
          $(question).find('.question-rank').val(index + 1);
        });
      }
    });
  }
});
