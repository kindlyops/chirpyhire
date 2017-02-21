$(document).on('turbolinks:load', function() {
  var conversation = $('.conversation:not([loaded])');
  if(conversation.length) {
    var readMessages = $('.read-messages');
    readMessages.scrollTop(readMessages.prop('scrollHeight'));
    var composer = $('.write-message textarea');

    composer.keydown(function(e) {
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo) {
        e.preventDefault();
        composer.closest('form').submit();
      }

      if(e.keyCode === 13 && combo) {
        composer.val(composer.val() + '\n');
      }
    });

    conversation.attr('loaded', true);
  }
});
