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
      exportUrl: '/contacts.csv',
      showExport: true,
      buttonsClass: 'success',
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
          field: 'created_at',
          title: 'First Response',
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
            ' progress-bar-striped bg-warning"',
            ' data-channel="candidacy-progress" data-contact-id="',
            value.contact_id, '" role="progressbar" aria-valuenow="',
            value.progress, '" aria-valuemin="3" ', 'aria-valuemax="100" ',
            'style="width: ', value.progress, '%;"></div></div>'].join('');
          }
        },{
          field: 'last_reply_at',
          title: 'Last Reply',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center last-reply'
            };
          },
          formatter: function(value, row, index) {
            return ['<span data-channel="last-reply" data-contact-id="',
            value.contact_id,'">', value.last_reply_at, '</span>'].join('');
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
            return ['<span class="badge ', value.badge_class, '" ',
            'data-channel="temperature" data-contact-id="',
            value.contact_id,'">', value.label, ' ',
            '<i class="fa ', value.icon_class,
                    '"></i></span>'].join('');
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
            value.id, '/conversation"><i class="fa fa-commenting-o"></i>',
            '</a>'].join('');
          }
        }]
    });

    contacts.attr('loaded', true);
  }
});
