$(document).on('load-success.bs.table', function() {
  var collection = $("[data-channel='candidacy-progress']:not([loaded])");

  if(collection.length) {
    R.forEach(function(contact) {
      var $contact = $(contact);
      var contactId = $contact.data('contact-id');
      var candidacyProgress = App['candidacyProgress' + contactId];

      var channel = { channel: 'CandidacyProgressesChannel',
                      contact_id: contactId };

      App['candidacyProgress' + contactId] = App.cable.subscriptions.create(
        channel, {
          model: function() {
            return $('[data-channel="candidacy-progress"]' +
                     '[data-contact-id="' + contactId + '"]');
          },
          received: function(data) {
            this.model().css('width', data + '%');
            this.model().attr('aria-valuenow', data);
          }
        });

      $contact.attr('loaded', true);
    }, collection);
  }
});
