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

    var input = $('#location-autocomplete input');
    $(input).on('focusout', function(e) {
      var searchRegex = /zipcode|city|state|county/;
      var isFiltered = window.location.search.match(searchRegex);

      if($(e.target).val() === "" && isFiltered) {
        e.preventDefault();
        $form = $('form.location-autocomplete-form');

        Turbolinks.visit($form.attr('action'));
      }
    });

    initMap();
    locationAutocomplete.attr('loaded', true);
  }
});

function initMap() {
  var input = $('#location-autocomplete input:not([loaded])');

  if(google && input.length) {
    var mapsOptions = {
      componentRestrictions: { country: 'us' },
      types: ['(regions)']
    };

    function preventStandardForm(e) {
      e.preventDefault();
    }

    function autoCallback(predictions, status) {
      if (status !== google.maps.places.PlacesServiceStatus.OK) {
        input.className = 'error';
        return;
      }
      // var placeService = new google.maps.places.PlacesService();
      // placeService.getDetails({ placeId: predictions[0].place_id }, function(place, status) {
      //   debugger;
      //   applyZipCodeSearch(place);
      // });
      input.addClass('success');
      input.val(predictions[0].description);
    }

    function queryAutocomplete(query) {
      var service = new google.maps.places.AutocompleteService();
      var options = R.merge(mapsOptions, { input: query });
      service.getPlacePredictions(options, autoCallback);
    }

    function handleTabbingOnInput(e) {
      if (e.which === 9 || e.keyCode === 9) {
        queryAutocomplete(e.target.value);
      }
    }

    function applyZipCodeSearch(place) {
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
    }

    var autocomplete = new google.maps.places.Autocomplete(input[0], mapsOptions);
    debugger;
    google.maps.event.addListener(autocomplete, 'place_changed', function () {
      var place = autocomplete.getPlace();
      if (typeof place.address_components === 'undefined') {
        queryAutocomplete(place.name);
      } else {
        applyZipCodeSearch(place);
      }
    });

    $(document).on('keydown', '#location-autocomplete', handleTabbingOnInput);
    $(document).on('submit', '.location-autocomplete-form', preventStandardForm);

    input.attr('loaded', true);
  }
}
