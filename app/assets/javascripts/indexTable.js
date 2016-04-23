$(document).on("page:change", function() {
  var initTableWithSearch = function() {
      var table = $('#tableWithSearch');
      var settings = {
          "sDom": "<'table-responsive't><'row'<p i>>",
          "destroy": true,
          "scrollCollapse": true,
          "oLanguage": {
              "sLengthMenu": "_MENU_ ",
              "sInfo": "Showing <b>_START_ to _END_</b> of _TOTAL_ entries"
          },
          "iDisplayLength": 5
      };
      table.dataTable(settings);
      $('#search-table').keyup(function() {
          table.fnFilter($(this).val());
      });
  }

  initTableWithSearch();
});
