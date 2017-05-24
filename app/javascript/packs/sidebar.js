import Popper from 'popper.js';

$(function() {
  let reference = $('.agent-status-button')[0];
  let popper = $('.agent-status-dropdown')[0];
  
  new Popper(reference, popper, {
    placement: 'right'
  });
  console.log(Popper);
});
