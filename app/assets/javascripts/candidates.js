$(document).on('turbolinks:load', function() {

  var candidates = $('.candidates:not([loaded])');

  if(candidates.length) {
    var screenedClass = function(isScreened) {
      if (isScreened) {
        return 'active';
      } else {
        return '';
      }
    };

    candidates.on('click', 'a.screened:not(.active)', function() {
      var $button = $(this);

      $.ajax({
        url: '/contacts/' + $button.data('candidate-id'),
        type: 'PUT',
        data: { contact: { screened: true } },
        success: function() {
          $button
            .addClass('active activating')
            .attr('title', $button.data('handle') + ' has been Screened!');
        },
        dataType: 'json'
      });
    });

    candidates.on('click', 'a.screened.active', function() {
      var $button = $(this);

      $.ajax({
        url: '/contacts/' + $button.data('candidate-id'),
        type: 'PUT',
        data: { contact: {  screened: false } },
        success: function() {
          $button
            .removeClass('active activating')
            .attr('title', $button.data('handle') + ' has been Screened!');
        },
        dataType: 'json'
      });
    });

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
            return '<span class="d-block btn ' + value.button_class + ' mb-2">' +
                      value.label +
                  '<i class="fa '+ value.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'qualifications',
          title: 'Qualifications',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.certification.button_class + ' mb-2">' +
                      value.certification.label +
                  '<i class="fa '+ value.certification.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn ' + value.skin_test.button_class + ' mb-2">' +
                      value.skin_test.label +
                  '<i class="fa '+ value.skin_test.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn ' + value.cpr_first_aid.button_class + ' mb-2">' +
                      value.cpr_first_aid.label +
                  '<i class="fa '+ value.cpr_first_aid.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'status',
          title: 'Status',
          sortable: true,
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.subscribed.button_class + ' mb-2">' +
                      value.subscribed.label +
                  '<i class="fa '+ value.subscribed.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn ' + value.status.button_class + ' mb-2">' +
                      value.status.label +
                  '<i class="fa '+ value.status.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'screened',
          title: 'Screened',
          sortable: true,
          formatter: function(value, row, index) {
            return [
                '<a role="button" data-candidate-id="', value.candidate_id,
                '" data-handle="', value.candidate_handle,
                '" title="Mark ', value.candidate_handle, ' as',
                ' Screened!"',' class="d-block btn btn-secondary ',
                screenedClass(value.candidate_screened),
                ' screened mr-2 ml-2"><i class="fa fa-check-circle fa-2x"></i>',
                '</a>'
            ].join('');
          }
      }]
    });

    candidates.attr('loaded', true);
  }
});
