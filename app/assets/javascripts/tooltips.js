$(document).on('turbolinks:load', function() {
  var toolTips = $('[data-toggle="tooltip"]:not([loaded])');
  toolTips.tooltip();
  toolTips.attr('loaded', true);
});
