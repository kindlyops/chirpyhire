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
      var input = $('#location-autocomplete input');
      var options = {
        componentRestrictions: { country: 'us' },
        types: ['(regions)']
      };

      var autocomplete = new google.maps.places.Autocomplete(input[0], options);

      autocomplete.addListener('place_changed', function() {
        var place = autocomplete.getPlace();
        var parser = document.createElement('a');
        $form = $('form.location-autocomplete-form');
        parser.href = $form.attr('action');

        var isZipcode = place.types[0] === "postal_code";
        var isState = place.types[0] === "administrative_area_level_1";
        var isCounty = place.types[0] === "administrative_area_level_2";
        var isCity = place.types[0] === "locality";

        if (isZipcode) {
          var location = 'zipcode=' + place.name;
        } else if (isState) { 
          var location = 'state=' + place.address_components[0].short_name;
        } else if (isCounty) {
          var county = 'county=' + place.name.replace(/ County/, "");
          var state = '&state=' + place.address_components[1].short_name;
          var location = county + state;
        } else if (isCity) {
          var city = 'city=' + place.name;
          var state = '&state=' + place.address_components[2].short_name;
          var location = city + state;
        }

        if (parser.search) {
          var url = $form.attr('action') + '&' + location;
        } else {
          var url = $form.attr('action') + '?' + location;
        }

        Turbolinks.visit(url);
      });

      $(document).on('focusout', input, function(e) {
        var searchRegex = /zipcode|city|state|county/;
        var isFiltered = window.location.search.match(searchRegex);

        if($(e.target).val() === "" && isFiltered) {
          e.preventDefault();
          $form = $('form.location-autocomplete-form');

          Turbolinks.visit($form.attr('action'));
        }
      }); 
    }

    initMap();
    locationAutocomplete.attr('loaded', true);
  }
});
