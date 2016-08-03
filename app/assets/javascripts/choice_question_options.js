$(document).on("turbolinks:load", function() {
  if($(".question #choice-question-options").length) {
    $(document).on('cocoon:before-insert', '#choice-question-options', function(e, option) {
      var lastOption = $('.nested-fields').last();
      var lastLetter = lastOption.find('.letter').val();
      var nextLetter = String.fromCharCode(lastLetter.charCodeAt(0) + 1);
      option.find('.letter').val(nextLetter);
      option.find('.letter-label').text(nextLetter);
    });



    $(document).on('cocoon:after-remove', '#choice-question-options', function(e, option) {
      option.attr("removed", true);
      var remainingOptions = $('.nested-fields').not("[removed=true]");
      var alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

      _.each(remainingOptions, function(remainingOption, index) {
        $remainingOption = $(remainingOption);
        $remainingOption.find('.letter').val(alphabet[index]);
        $remainingOption.find('.letter-label').text(alphabet[index]);
      });
    });
  }
});
