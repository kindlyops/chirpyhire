$(document).on('turbolinks:load', function() {

  if($('.candidates').length) {
    var newCandidateTables = $('.candidates table:not([loaded])');
    newCandidateTables.DataTable({
      pageLength: 9,
      lengthChange: false
    });
    newCandidateTables.attr('loaded', true);
  }
});
