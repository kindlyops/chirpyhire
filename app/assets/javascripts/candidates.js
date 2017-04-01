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
          field: 'person',
          title: 'Candidate',
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
          field: 'created_at',
          title: 'First Seen',
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
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
            return ['<span data-channel="last-reply" data-contact-id="',
            value.contact_id,'">', value.last_reply_at, '</span>'].join('');
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
            return ['<a class="btn btn-primary btn-block" href="/contacts/',
            value.id, '/conversation"><i class="fa fa-commenting fa-2x"></i>',
            '</a>'].join('');
          }
        }]
    });

    candidates.attr('loaded', true);
  }
});
