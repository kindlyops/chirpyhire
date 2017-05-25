$(function() {
  $(document).on('click', '.export-caregivers', function(e) {
    e.preventDefault();
    window.location.href = '/caregivers.csv' + location.search;
   });

  $(document).on('click', '.apply', function(e) {
    e.preventDefault();
    $form = $(this).closest('form');

    var parser = document.createElement('a');
    parser.href = $form.attr('action');

    if (parser.search) {
      var url = $form.attr('action') + '&' + $form.serialize();
    } else {
      var url = $form.attr('action') + '?' + $form.serialize();
    }

    window.location.href = url;
  });

  $(document).on('click', '.cancel', function(e) {
    e.preventDefault();
    $form = $(this).closest('form');
    $form.find('input[type=checkbox]:not(.active)').removeAttr('checked');
    $form.find('input[type=checkbox].active').prop('checked', true);
    $form.find('.dropdown-toggle').click();
  });
});
