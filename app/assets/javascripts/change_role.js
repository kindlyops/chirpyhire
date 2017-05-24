$(document).on('ready', function() {
  $(document).on('click', '.settings .change-role .dropdown-item', function(e) {
    e.preventDefault();
    $(this).find('form').submit();
  });
});
