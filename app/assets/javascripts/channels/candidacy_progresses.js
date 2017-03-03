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
            return $contact;
          },
          received: function(data) {
            this.model().css({ width: data.progress + '%' });
            this.model().attr('aria-valuenow', data.progress);
          }
        });

      $contact.attr('loaded', true);
    }, collection);
  }
});
