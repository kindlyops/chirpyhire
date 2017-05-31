$(document).on('ready', function() {
  var notes = $('#notes_tab');

  if (notes.length) {
    $(document).on('focus', '#reply_container textarea', function() {
      $('#reply_container').addClass('has_focus');
    });

    $(document).on('focusout', '#reply_container textarea', function() {
      if(!$('#reply_container textarea').val().trim().length) {
        $('#reply_container textarea').val('');
        $('#reply_container').removeClass('has_focus');
      }
    });

    $(document).on('click', '.note_send', function(e) {
      e.preventDefault();
      $('form#new_note').submit();
    });

    $(document).on('click', '#note-show-container button.delete', function(e) {
      var noteToDelete = $(this).closest('#note-show-container').clone();
      noteToDelete.addClass('standalone');

      var modal = $('.modal');
      var notice = '<p class="mb-3">Are you sure you want to delete this note? This cannot be undone.</p>';
      modal.find('.modal-body').empty().append(notice).append(noteToDelete);
      modal.modal();

      modal.on('click', '.modal-footer button.delete', function(e) {
        e.preventDefault();
        noteToDelete.find('form.destroy-note').submit();
      });
    });

    $(document).on('click', '#note-show-container button.edit', function(e) {
      var noteId = $(this).closest('#note-show-container').data('note-id');
      $(this).closest('#note-show-container').prop('hidden', true);
      $('#note-edit-container[data-note-id="'+ noteId + '"').removeProp('hidden');
    });

    $(document).on('click', '#note-edit-container #cancel_edit', function(e) {
      var noteId = $(this).closest('#note-edit-container').data('note-id');
      $(this).closest('#note-edit-container').prop('hidden', true);
      $('#note-show-container[data-note-id="'+ noteId + '"').removeProp('hidden');
    });

    $(document).on('click', '#note-edit-container #commit_edit', function(e) {
      $(this).closest('form').submit();
    });

    $(document).on('keydown', '#note-edit-container #note_body', function(e) {
      var body = $('#note-edit-container #note_body').val().trim();
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo && body.length) {
        e.preventDefault();
        $(this).closest('form').submit();
      }
    });

    $(document).on('keydown', '#new_note #note_body', function(e) {
      var body = $('#new_note #note_body').val().trim();
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo && body.length) {
        e.preventDefault();
        $(this).closest('form').submit();
      }
    });
  }

});
