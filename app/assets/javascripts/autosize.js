$(document).on('ready', function() {

  var textAreas = $('textarea[data-autosize]:not([loaded])');

  if(textAreas.length) {
    autosize(textAreas);
    textAreas.attr('loaded', true);
  }
});
