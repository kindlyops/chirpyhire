import Popper from 'popper.js';

$(function() {
  $(document).on('click', function(e) {
    let withinDropdown = $(e.target).closest('.account-status-dropdown').length;
    let withinToggle = $(e.target).closest('.account-status-container').length;
    if (!withinDropdown && !withinToggle) {
      $('body').removeClass('show-account-status-dropdown');
    }
  });

  $(document).on('click', '.account-status-container', function(e) {
    e.preventDefault();
    let isOpen = $('body').hasClass('show-account-status-dropdown');

    if (isOpen) {
      $('body').removeClass('show-account-status-dropdown');
    } else {
      $('body').addClass('show-account-status-dropdown');
      let reference = $('.account-status-container');
      let popper = $('.account-status-dropdown');
      
      new Popper(reference, popper, {
        placement: 'right',
        modifiers: {
          offset: {
            offset: '-130px, 50%'
          }
        }
      });
    }
  });
});
