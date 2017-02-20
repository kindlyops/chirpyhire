$(document).on('turbolinks:load', function() {

  if($('.subscribers').length) {
    var newSubscriberTables = $('.subscribers table:not([loaded])');
    newSubscriberTables.DataTable({
      pageLength: 9,
      lengthChange: false
    });
    newSubscriberTables.attr('loaded', true);
  }
});
