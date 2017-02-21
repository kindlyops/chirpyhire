$(document).on('turbolinks:load', function() {

  var candidates = $('.candidates:not([loaded])');

  if(candidates.length) {
    candidates.find('table').bootstrapTable({
      classes: 'table table-no-bordered',
      search: true,
      sortStable: true,
      iconsPrefix: 'fa',
      smartDisplay: true,
      mobileResponsive: true,
      columns: [{
          field: 'contact_information',
          title: 'Contact Info',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.handle.button_class + ' mb-2">' +
                      value.handle.label +
                  '<i class="fa '+ value.handle.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn ' + value.phone_number.button_class + '">' +
                      value.phone_number.label +
                  '<i class="fa '+ value.phone_number.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'location',
          title: 'Location',
          sortable: true,
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
          field: 'subscribed',
          title: 'Subscribed',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.button_class + ' mb-2">' +
                      value.label +
                  '<i class="fa '+ value.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'status',
          title: 'Status',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn ' + value.button_class + ' mb-2">' +
                      value.label +
                  '<i class="fa '+ value.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }],
      url: '/candidacies.json'
    });

    candidates.attr('loaded', true);
  }
});
