import Popper from 'popper.js';

$(function() {
  $(document).on('click', function(e) {
    let withinDropdown = $(e.target).closest('.agent-status-dropdown').length;
    let withinToggle = $(e.target).closest('.agent-status-container').length;
    if (!withinDropdown && !withinToggle) {
      $('body').removeClass('show-agent-status-dropdown');
    }
  });

  $(document).on('click', '.agent-status-container', function(e) {
    e.preventDefault();
    let isOpen = $('body').hasClass('show-agent-status-dropdown');

    if (isOpen) {
      $('body').removeClass('show-agent-status-dropdown');
    } else {
      $('body').addClass('show-agent-status-dropdown');
      let reference = $('.agent-status-container');
      let popper = $('.agent-status-dropdown');
      
      new Popper(reference, popper, {
        placement: 'right',
        modifiers: {
          offset: {
            offset: '-100px, 50%'
          }
        }
      });
    }
  });
});
