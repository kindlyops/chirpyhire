$(document).on('turbolinks:load', function() {
  var toolTips = $('[data-toggle="tooltip"]:not([loaded])');
  toolTips.attr('data-animation', false);
  toolTips.tooltip();
  toolTips.attr('loaded', true);
});
