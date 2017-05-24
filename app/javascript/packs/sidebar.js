import Popper from 'popper.js';

$(function() {
  let reference = $('.agent-status-button');
  let popper = $('.agent-status-dropdown');
  
  new Popper(reference, popper, {
    placement: 'right'
  });
  console.log(Popper);
});
