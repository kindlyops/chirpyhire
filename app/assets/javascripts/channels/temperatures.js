$(document).on('load-success.bs.table', function() {
  var collection = $("[data-channel='temperature']:not([loaded])");

  if(collection.length) {
    R.forEach(function(contact) {
      var $contact = $(contact);
      var contactId = $contact.data('contact-id');
      var temperature = App['temperature' + contactId];

      var channel = { channel: 'TemperaturesChannel',
                      contact_id: contactId };

      App['temperature' + contactId] = App.cable.subscriptions.create(
        channel, {
          model: function() {
            return $('[data-channel="temperature"]' +
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
