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
      buttonsClass: 'primary',
      search: true,
      showRefresh: true,
      checkboxHeader: true,
      showExport: true,
      toolbar: '#toolbar',
      icons: {
        paginationSwitchDown: 'fa-arrow-circle-o-down',
        paginationSwitchUp: 'fa-arrow-circle-o-up',
        refresh: 'fa-refresh',
        toggle: 'fa-toggle-on',
        columns: 'fa-th-list',
        export: 'fa-cloud-download'
      },
      exportUrl: '/candidates.csv',
      url: '/candidates.json',
      columns: [{
        field: 'select',
        checkbox: true
      },{
          field: 'person',
          title: 'Nickname (internal)',
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<p>'+
            '<a class="btn btn-secondary btn-block" data-toggle="collapse" '+
            'href="#showPhone'+ value.id + '" aria-expanded="false" '+
            'aria-controls="showPhone'+ value.id + '">' +
            '<span>' +
                value.handle.label +
            '<i class="fa '+ value.handle.icon_class + ' ml-2"></i></span>' +
            '</a></p>' +
            '<div class="collapse" id="showPhone'+ value.id + '">' +
              '<span>' +
                value.phone_number.label +
              '</span>' +
            '</div>';
          }
      }, {
          field: 'created_at',
          title: 'First Seen',
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return ['<p>', value, '</p>'].join('');
          }
      }, {
          field: 'last_reply_at',
          title: 'Last Reply',
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return ['<p data-channel="last-reply" data-contact-id="',
            value.contact_id,'">', value.last_reply_at, '</p>'].join('');
          }
      },{
          field: 'message',
          title: 'Chat',
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center message-caregiver'
            };
          },
          formatter: function(value, row, index) {
            return ['<p>', '<a class="btn btn-primary btn-block" href="/contacts/',
            value.id, '/conversation"><i class="fa fa-commenting fa-2x"></i>',
            '</a>', '</p>'].join('');
          }
        }]
    });

    candidates.attr('loaded', true);
  }
});
