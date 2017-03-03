$(document).on('load-success.bs.table', function() {
  var collection = $("[data-channel='last-reply']:not([loaded])");

  if(collection.length) {
    R.forEach(function(contact) {
      var $contact = $(contact);
      var contactId = $contact.data('contact-id');
      var lastReply = App['lastReply' + contactId];

      var channel = { channel: 'LastRepliesChannel',
                      contact_id: contactId };

      App['lastReply' + contactId] = App.cable.subscriptions.create(
        channel, {
          model: function() {
            return $('[data-channel="last-reply"]' +
                     '[data-contact-id="' + contactId + '"]');
          },
          received: function(data) {
            var $data = $(data);

            if($data.text() !== this.model().text()) {
              this.model().replaceWith($data);
            }
          }
        });

      $contact.attr('loaded', true);
    }, collection);
  }
});
