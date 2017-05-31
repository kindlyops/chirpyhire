$(document).on('ready', function() {
  var messages = $('.messages');
  if (messages.length) {
    var composer = $('form.new_message .message-input');

    composer.keydown(function(e) {
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo) {
        var $form = composer.closest('form');
        var messageBody = $form.find('.message-input');
        e.preventDefault();
        if(messageBody.val().length) {
          $form.submit();
          messageBody.val('');
        }
      }
    });

    if (messages.find('.client_body').length) {
      var setChannelsScrollerHeight = function(window_h) {
        var top_nav_offset = $('nav.navbar.top').outerHeight();
        var top_subNav_offset = $(".team_menu").outerHeight();
        var height = window_h - top_subNav_offset - top_nav_offset;
        $('#notes_scroller').css('height', height);
      };

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

        var flex_contents_height = cached_wh - msgs_scroller_y;
        $("#flex_contents > .panel").css("height", flex_contents_height);
        setChannelsScrollerHeight(cached_wh);
      }

      $(window).resize(resizeScroller);
      resizeScroller();
    }
    
    $('#msgs_scroller_div').scrollTop($('#msgs_div').prop('scrollHeight') + 100);
  }
});
