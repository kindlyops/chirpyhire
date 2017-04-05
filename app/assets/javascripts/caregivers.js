$(document).on('turbolinks:load', function() {

  var caregiversNav = $('.caregivers-nav:not([loaded])');

  if(caregiversNav.length) {
    $(document).on('click', '.apply', function(e) {
      e.preventDefault();
      $form = $(this).closest('form');
      Turbolinks.visit($form.attr('action') + '&' + $form.serialize());
    });

    $(document).on('click', '.cancel', function(e) {
      e.preventDefault();
      $form = $(this).closest('form');
      $form.find('input[type=checkbox]:not(.active)').removeAttr('checked');
      $form.find('input[type=checkbox].active').prop('checked', true);
      $form.find('.dropdown-toggle').click();
    });

    caregiversNav.attr('loaded', true);
  }
});
