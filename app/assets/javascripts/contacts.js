$(document).on('turbolinks:load', function() {

  var contacts = $('.contacts:not([loaded])');

  if(contacts.length) {
    contacts.find('table').bootstrapTable({
      classes: 'table table-no-bordered',
      smartDisplay: true,
      pagination: true,
      paginationNextText: 'Next &rsaquo;',
      paginationPreText: '&lsaquo; Prev',
      sidePagination: 'server',
      mobileResponsive: true,
      iconsPrefix: 'fa',
      search: true,
      showRefresh: true,
      checkboxHeader: true,
      icons: {
        paginationSwitchDown:'fa-arrow-circle-o-down',
        paginationSwitchUp:'fa-arrow-circle-o-up',
        refresh: 'fa-refresh',
        toggle: 'fa-toggle-on',
        columns: 'fa-th-list',
        export: 'fa-cloud-download'
      },
      showExport: true,
      url: '/contacts.json',
      columns: [{
          field: 'select',
          checkbox: true
        },{
          field: 'person',
          title: 'Candidate',
          sortable: true
      }]
    });

    contacts.attr('loaded', true);
  }
});
