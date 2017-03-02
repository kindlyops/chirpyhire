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
          field: 'nickname',
          title: 'Nickname (internal)',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          }
        },{
          field: 'first_activity',
          title: 'First Activity',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          }
        },{
          field: 'survey_progress',
          title: 'Survey Progress',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return ['<div class="progress">', '<div class="progress-bar',
            ' progress-bar-striped bg-warning" ',
            'role="progressbar" aria-valuenow="75" aria-valuemin="0" ',
            'aria-valuemax="100" style="width: 75%;"></div></div>'].join('');
          }
        },{
          field: 'last_activity',
          title: 'Last Activity',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          }
        },{
          field: 'temperature',
          title: 'Temperature',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center temperature'
            };
          },
          formatter: function(value, row, index) {
            return ['<span class="badge badge-danger">Hot ',
                    '<i class="fa fa-thermometer-full"></i>',
                    '</span>'].join('');
          }
        },{
          field: 'message',
          title: 'Message',
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center message-caregiver'
            };
          },
          formatter: function(value, row, index) {
            return ['<a class="btn btn-primary btn-block" href="/#">',
                    '<i class="fa fa-commenting-o"></i>','</a>'].join('');
          }
        }],
      data: [{
        nickname: 'Witty Ox',
        first_activity: '2/12/17 3:15pm',
        survey_progress: '75%',
        last_activity: '2/14/17 5:15pm',
        temperature: 'Hot',
        message: 'Message Me!'
      }]
    });

    contacts.attr('loaded', true);
  }
});
