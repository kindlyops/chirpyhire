$(document).on('turbolinks:load.conversation', function() {
  var collection = $("[data-channel='messages']");
  var contactId = collection.data('contact-id');

  if(App.messages && App.messages.contactId() !== contactId) {
    App.messages.unsubscribe();
  }

  var channel = { channel: 'MessagesChannel', contact_id: contactId };
  App.messages = App.cable.subscriptions.create(channel, {
    collection: function() {
      return $("[data-channel='messages']");
    },

    contactId: function() {
      return this.collection().data('contact-id');
    },

    lastMessageGroup: function() {
      return this.collection().find('.message-group').last();
    },

    scrollToBottom: function() {
      this.collection().scrollTop(this.collection().prop('scrollHeight'));
    },

    clearComposer: function() {
      $('.write-message textarea').val('');;
    },

    received: function(data) {
      var $data = $(data);

      if ($data.hasClass('message-group')) {
        this.collection().append(data);
      } else {
        this.lastMessageGroup().find('ul').append(data);
      }

      if (this.lastMessageGroup().hasClass('organization')) {
        this.clearComposer();
      }

      this.scrollToBottom();
    }
  });
});
