$(function() {
  if($('.settings.contact-stages').length !== 0) {
    $('.settings.contact-stages .sortable').sortable({
      axis: 'y',
      scroll: 'true',
      handle: '.contact-stage-handle',
      update: function() {
        var $this = $(this);
        var orgId = $('.settings.contact-stages').data('organization-id');
        var url = '/organizations/' + orgId + '/settings/candidate/stages/reorder';
        $.post(url, $(this).sortable('serialize'));
      }
    });
  }
});
