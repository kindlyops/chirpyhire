$(document).on('ready', function() {
  $(document).on('click', '.settings .person .role .dropdown-item', function(e) {
    e.preventDefault();
    $(this).find('form').submit();
  });
});
