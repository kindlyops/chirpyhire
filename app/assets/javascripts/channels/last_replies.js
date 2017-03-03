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

      App['lastReply' + contactId].setModel($contact);

      $contact.attr('loaded', true);
    }, collection);
  }
});
