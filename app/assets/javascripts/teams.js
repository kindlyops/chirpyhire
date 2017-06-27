$(document).on('ready', function() {
  $(document).on('click', '.teams form#new_membership', function(e) {
    e.stopPropagation();
  });
});
