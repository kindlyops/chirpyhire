$(document).on('turbolinks:load', function() {
  var toolTips = $('[data-toggle="tooltip"]:not([loaded])');
  toolTips.tooltip();
  toolTips.attr('loaded', true);
});

$(document).on('load-success.bs.table', function() {
  var toolTips = $('[data-toggle="tooltip"]:not([loaded])');
  toolTips.tooltip();
  toolTips.attr('loaded', true);
});
