$(document).on('turbolinks:load', function() {
  var collection = $("[data-channel='messages']");

  if(collection.length) {
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

      lastDay: function() {
        return this.collection().find('.day_container').last();
      },

      scrollToBottom: function() {
        this.collection().scrollTop(this.days().prop('scrollHeight') + 100);
      },

      days: function() {
        return this.collection().find('#msgs_div');
      },

      lastDayMessages: function() {
        return this.lastDay().find('.day_msgs');
      },

      received: function(data) {
        var $data = $(data);

        if ($data.hasClass('day_container')) {
          this.days().append(data);
        } else {
          this.lastDayMessages().append(data);
        }

        this.scrollToBottom();
      }
    });
  }
});
