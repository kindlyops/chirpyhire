$(document).on('ready', function() {

  var autoResize = $('textarea[data-autoresize]:not([loaded])');

  if(autoResize.length) {
    autoResize.textareaAutoSize();
    autoResize.attr('loaded', true);
  }
});
