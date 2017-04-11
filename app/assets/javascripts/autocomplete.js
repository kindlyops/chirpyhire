$(document).on('turbolinks:load', function() {

  var locationAutocomplete = $('#location-autocomplete:not([loaded])');

  if(locationAutocomplete.length) {
    $(document).on('click', '#location-autocomplete', function() {
      $(this).addClass('expanded');
      $(this).find('input').attr('placeholder', 'Search zipcode, city, county, or state');
    });

    $(document).on('focusout', '#location-autocomplete', function() {
      $(this).removeClass('expanded');
      $(this).find('input').attr('placeholder', 'Anywhere');
    });

    function initMap() {
      var input = $('#location-autocomplete input')[0];
      var options = {
        componentRestrictions: { country: 'us' },
        types: ['(regions)']
      };

      var autocomplete = new google.maps.places.Autocomplete(input, options);

      autocomplete.addListener('place_changed', function() {
        var place = autocomplete.getPlace();
        $(input).val(place.name);
      });
    }

    initMap();
    locationAutocomplete.attr('loaded', true);
  }
});
