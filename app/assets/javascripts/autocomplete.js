$(document).on('turbolinks:load', function() {

  var locationAutocomplete = $('#location-autocomplete:not([loaded])');

  if(locationAutocomplete.length) {
    $(document).on('focusin', '#location-autocomplete', function() {
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

  if(input.length && google) {

    var options = {
      componentRestrictions: { country: 'us' },
      types: ['(regions)']
    };

    var autocomplete = new google.maps.places.Autocomplete(input[0], options);

    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();

      if (place.types) {
        var parser = document.createElement('a');
        $form = $('form.location-autocomplete-form');
        parser.href = $form.attr('action');

        var placeType = place.types[0];
        var isZipcode = placeType === "postal_code";
        var isState = placeType === "administrative_area_level_1";
        var isCounty = placeType === "administrative_area_level_2";
        var isCity = placeType === "locality";
        var stateComponent = R.find(R.where({types: R.contains('administrative_area_level_1')}), place.address_components);

        if (isZipcode) {
          var location = 'zipcode=' + place.name;
        } else if (isState) {
          var location = 'state=' + stateComponent.short_name;
        } else if (isCounty) {
          var county = 'county=' + place.name.replace(/ County/, "");
          var state = '&state=' + stateComponent.short_name;
          var location = county + state;
        } else if (isCity) {
          var city = 'city=' + place.name;
          var state = '&state=' + stateComponent.short_name;
          var location = city + state;
        }

        if (parser.search) {
          var url = $form.attr('action') + '&' + location;
        } else {
          var url = $form.attr('action') + '?' + location;
        }

        Turbolinks.visit(url);
      }
    });

    google.maps.event.addDomListener(input[0], 'keydown', function(e){
      var keyCode = e.keyCode || e.which;
      var noneSelected = $('.pac-item-selected').length === 0;
      var isTabOrEnter = keyCode === 13 || keyCode === 9;
      var isSearching = isTabOrEnter && noneSelected && !e.triggered;

      if(isSearching) {
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 40 });
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 13, triggered: true });
      }
    });

    $(document).on('submit', 'form.location-autocomplete-form', function(e) {
      e.preventDefault();
    });

    input.attr('loaded', true);
  }
}
