$(document).on('turbolinks:load', function() {
  var notes = $('#notes_tab:not([loaded])');

  if (notes.length) {

    $(document).on('focus', '#reply_container textarea', function() {
      $('#reply_container').addClass('has_focus');
    });

    $(document).on('focusout', '#reply_container textarea', function() {
      $('#reply_container').removeClass('has_focus');
    });

    notes.attr('loaded', true);
  }
});
