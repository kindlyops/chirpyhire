$(document).on('ready', function() {
  $(document).on('click', '#upload', function(e) {
    e.preventDefault();
    $('.settings #avatar').click();
  });

  $(document).on('change', '#avatar', function(e) {
    e.preventDefault();
    $('.edit_profile_picture').submit();
  });
});
