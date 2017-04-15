$(document).on('turbolinks:load', function() {

  var messages = $('.messages:not([loaded])');

  if(messages.length) {
    var resizeScroller = function() {
      var height = window.innerHeight - 200;
      $('#msgs_scroller_div').css('height', height + 'px');
    }

    $(window).resize(resizeScroller);
    resizeScroller();
    messages.attr('loaded', true);
  }
});
