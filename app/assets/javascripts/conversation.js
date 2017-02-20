$(document).on('turbolinks:load', function() {
  var conversation = $('.conversation:not([loaded])');
  if(conversation.length) {
    var readMessages = $('.read-messages');
    readMessages.scrollTop(readMessages.prop('scrollHeight'));
    conversation.attr('loaded', true);
  }
});
