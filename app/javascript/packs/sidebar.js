import Popper from 'popper.js';

$(function() {
  $(document).on('click', function(e) {
    var withinDropdown = $(e.target).closest('.agent-status-dropdown').length;
    var openingDropdown = $(e.target).closest('.agent-status-container').length;
    if (!openingDropdown && !withinDropdown) {
      $('body').removeClass('show-agent-status-dropdown');
      Popper.destroy();
    }
  });

  $(document).on('click', '.agent-status-container', function(e) {
    e.preventDefault();
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
  });
});
