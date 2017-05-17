$(document).on('ready', function() {
  var model = $("[data-channel='sidebar']:not([loaded])");

  if(model.length) {
    var channel = { channel: 'SidebarChannel' };
    App.sidebar = App.cable.subscriptions.create(channel, {
      model: function() {
        return $("[data-channel='sidebar']");
      },

      conversations: function() {
        return this.model().find('.conversations');
      },

      currentContactId: function() {
        return location.pathname.substr(location.pathname.lastIndexOf('/') + 1);
      },

      activeConversation: function($data) {
        return $data.find('a[data-contact-id="' + this.currentContactId() + '"]');
      },

      received: function(data) {
        var $data = $(data);

        this.activeConversation($data).addClass('active')
        this.conversations().replaceWith($data);
      }
    });

    model.attr('loaded', true);
  }
});
