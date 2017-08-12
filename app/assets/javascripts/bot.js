$(function() {
  $('.collapse.bot-action').on('shown.bs.collapse', function () {
    var autoResize = $(this).find('textarea[data-autoresize]');
    autoResize.trigger('input');
  })
});
