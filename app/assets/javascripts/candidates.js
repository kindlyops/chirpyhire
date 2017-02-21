$(document).on('turbolinks:load', function() {

  var candidates = $('.candidates:not([loaded])');

  if(candidates.length) {
    candidates.find('table').bootstrapTable({
      classes: 'table table-hover table-no-bordered',
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
            return '<span class="d-block btn btn-secondary mb-2">' +
                      value.handle.label +
                  '<i class="fa '+ value.handle.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn btn-secondary">' +
                      value.phone_number.label +
                  '<i class="fa '+ value.phone_number.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'location',
          title: 'Location',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn btn-secondary mb-2">' +
                      value.location.label +
                  '<i class="fa '+ value.location.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'availability',
          title: 'Availability',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn btn-secondary mb-2">' +
                      value.schedule.label +
                  '<i class="fa '+ value.schedule.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn btn-secondary">' +
                      value.transportation.label +
                  '<i class="fa '+ value.transportation.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'experience',
          title: 'Experience',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn btn-secondary mb-2">' +
                      value.experience.label +
                  '<i class="fa '+ value.experience.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'qualifications',
          title: 'Qualifications',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn btn-secondary mb-2">' +
                      value.certification.label +
                  '<i class="fa '+ value.certification.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn btn-secondary">' +
                      value.skin_test.label +
                  '<i class="fa '+ value.skin_test.icon_class + ' ml-2"></i>' +
                  '</span>' +
                  '<span class="d-block btn btn-secondary">' +
                      value.cpr_first_aid.label +
                  '<i class="fa '+ value.cpr_first_aid.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'subscribed',
          title: 'Subscribed',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn btn-secondary mb-2">' +
                      value.subscribed.label +
                  '<i class="fa '+ value.subscribed.icon_class + ' ml-2"></i>' +
                  '</span>';
          }
      }, {
          field: 'status',
          title: 'Status',
          sortable: true,
          formatter: function(value, row, index) {
            return '<span class="d-block btn btn-secondary mb-2">' +
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
