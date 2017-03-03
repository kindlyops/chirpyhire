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
            return this._model;
          },
          setModel: function(model) {
            this._model = model;
          },
          received: function(data) {
            var $data = $(data);

            if($data.text() !== this.model().text()) {
              this.model().replaceWith($data);
              this.setModel($data);
            }
          }
        });

      App['temperature' + contactId].setModel($contact);

      $contact.attr('loaded', true);
    }, collection);
  }
});
