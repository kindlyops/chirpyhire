$(document).on('turbolinks:load', function() {

  var autoResize = $('textarea[data-autoresize]:not([loaded])');

  if(autoResize.length) {

    $(document).on('keyup', autoResize, function (e) {
      if (e.keyCode === 13) {          
        if(e.shiftKey){
          $(e.target).attr('rows', parseInt($(e.target).attr('rows')) + 1);
          $(e.target).css('height', 'auto');
          e.stopPropagation();
        }
      }
    });

    autoResize.attr('loaded', true);
  }
});
