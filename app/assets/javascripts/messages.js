$(document).on('turbolinks:load', function() {

  var messages = $('.messages:not([loaded])');

  if(messages.length) {
    var resizeScroller = function() {
      var cached_wh = $(window).height();

      var msgs_scroller_y = $(".client_body").offset().top;
      var footer_outer_h = $(".footer").outerHeight();

      var msgs_scroller_height = cached_wh - msgs_scroller_y - footer_outer_h;
      $('#msgs_scroller_div').css('height', msgs_scroller_height);

      var end_div = $("#end_div");
      var end_display_padder = $("#end_display_padder");
      end_div.css("height", "");
      end_display_padder.css("height", "");
      var end_display_div = $("#end_display_div");
      var h = end_display_div.outerHeight();
      var allowed_h;
      allowed_h = $('#msgs_scroller_div')[0].scrollHeight - $('#msgs_div').outerHeight();
      allowed_h -= 32;
      if (allowed_h > h) {
        end_display_padder.css("height", allowed_h - h);
      }
      end_div.height(allowed_h);
    }

    $(window).resize(resizeScroller);
    resizeScroller();

    var scrollToBottom = function() {
      $('#msgs_scroller_div').scrollTop($('#msgs_div').offset().top);
    }

    if ($('.messages').length) {
      scrollToBottom();
    }

    messages.attr('loaded', true);
  }
});
