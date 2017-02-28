App.messages = App.cable.subscriptions.create("MessagesChannel", {
  collection: function() {
    return $("[data-channel='messages']");
  },

  connected: function() {
    setTimeout(function() {
      this.install();
      this.followCurrentContact();
    }.bind(this), 1000);
  },

  disconnected: this.uninstall,

  received: function(data) {
    if (!accountIsCurrentAccount(data.message)) {
      this.collection().append(data.message));
    }
  },

  accountIsCurrentAccount: function(message) {
    $(message).attr('data-account-id') === $('meta[name=current-account]').attr('id');
  },

  followCurrentContact: function() {
    var contactId = this.collection().data('contact-id');

    if (contactId) {
      this.perform('follow', contact_id: contactId);
    } else {
      this.perform('unfollow');
    }
  },

  install: function() {
    if (!this.installedPageChangeCallback) {
      this.installedPageChangeCallback = true;
      $(document).on('turbolinks:load.conversation', this.followCurrentContact.bind(this));
    }
  },

  uninstall: function() {
    $(document).off('.conversation');
  }
});
