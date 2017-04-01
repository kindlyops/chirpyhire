$(document).on('turbolinks:load', function() {

  var candidates = $('.candidates:not([loaded])');

  if(candidates.length) {
    candidates.find('table').bootstrapTable({
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
      buttonsClass: 'success',
      icons: {
        paginationSwitchDown:'fa-arrow-circle-o-down',
        paginationSwitchUp:'fa-arrow-circle-o-up',
        refresh: 'fa-refresh',
        toggle: 'fa-toggle-on',
        columns: 'fa-th-list',
        export: 'fa-cloud-download'
      },
      exportUrl: '/candidates.csv',
      showExport: true,
      url: '/candidates.json',
      columns: [{
          field: 'select',
          checkbox: true
        },{
          field: 'person',
          title: 'Candidate',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<span class="btn ' + value.phone_number.button_class + '">' +
                    value.phone_number.label +
                    '<i class="fa '+ value.phone_number.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn ' + value.handle.button_class + ' mb-2">' +
                      value.handle.label +
                  '<i class="fa '+ value.handle.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'zipcode',
          title: 'Location',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.button_class + ' mb-2">' +
                      value.label +
                  '<i class="fa '+ value.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'availability',
          title: 'Availability',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.availability.button_class + ' mb-2">' +
                      value.availability.label +
                  '<i class="fa '+ value.availability.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn ' + value.transportation.button_class + '">' +
                      value.transportation.label +
                  '<i class="fa '+ value.transportation.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'experience',
          title: 'Experience',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return ['<a class="btn btn-primary btn-block" href="/contacts/',
            value.id, '/conversation"><i class="fa fa-commenting fa-2x"></i>',
            '</a>'].join('');
          }
        }]
    });

    candidates.attr('loaded', true);
  }
});
