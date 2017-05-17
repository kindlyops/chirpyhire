$(document).on('ready', function() {
  var profile = $('.settings .profile:not([loaded])');
  if(profile.length) {
    $(document).on('click', '.profile #upload', function(e) {
      e.preventDefault();
      $('.settings .profile #avatar').click();
    });

    $(document).on('change', '.profile #avatar', function(e) {
      e.preventDefault();
      $('.profile .edit_profile_picture').submit();
    });
    profile.attr('loaded', true);
  }
});
