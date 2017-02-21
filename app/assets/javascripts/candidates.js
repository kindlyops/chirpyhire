$(document).on('turbolinks:load', function() {

  var candidates = $('.candidates:not([loaded])');

  if(candidates.length) {
    function compareProperty(a, b) {
      return (a || b) ? (!a ? -1 : !b ? 1 : a.localeCompare(b)) : 0;
    }

    candidates.find('table').bootstrapTable({
      classes: 'table table-no-bordered',
      search: true,
      sortStable: true,
      iconsPrefix: 'fa',
      smartDisplay: true,
      mobileResponsive: true,
      columns: [{
          field: 'contact',
          title: 'Contact',
          sortable: true,
          sorter: function(first, second) {
            return compareProperty(first.handle.label, second.handle.label) ||
                   compareProperty(first.phone_number.label, second.phone_number.label);
          },
          cellStyle: function(value, row, index, field) {
            return {
              classes: 'text-center'
            };
          },
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.handle.button_class + ' mb-2">' +
                      value.handle.label +
                  '<i class="fa '+ value.handle.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<a role="button" href="/subscribers/' + value.phone_number.subscriber_id + '/conversation" class="btn ' + value.phone_number.button_class + '">'
                    + value.phone_number.label +
                    '<i class="fa '+ value.phone_number.icon_class + ' ml-2"></i>' +
                  '</a>';
          }
      }, {
          field: 'location',
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
          sorter: function(first, second) {
            return compareProperty(first.availability.label, second.availability.label) ||
                   compareProperty(first.transportation.label, second.transportation.label);
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
          sorter: function(first, second) {
            return compareProperty(first.certification.label, second.certification.label) ||
                   compareProperty(first.skin_test.label, second.skin_test.label) ||
                   compareProperty(first.cpr_first_aid.label, second.cpr_first_aid.label)
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
          sorter: function(first, second) {
            return compareProperty(first.subscribed.label, second.subscribed.label) ||
                   compareProperty(first.status.label, second.status.label);
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
      }],
      url: '/candidacies.json'
    });

    candidates.attr('loaded', true);
  }
});
