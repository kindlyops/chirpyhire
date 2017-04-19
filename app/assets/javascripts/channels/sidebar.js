$(document).on('turbolinks:load', function() {
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

      received: function(data) {
        var $data = $(data);

        this.conversations().replaceWith($data);
      }
    });

    model.attr('loaded', true);
  }
});
