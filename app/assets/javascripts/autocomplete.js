function initAccountSearch() {
  var input = $('#location-search input:not([loaded])');

  if(input.length && typeof google !== "undefined") {
    var options = {
      componentRestrictions: { country: 'us' },
      types: ['address']
    };

    var autocomplete = new google.maps.places.Autocomplete(input[0], options);

    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();
      var $form = $('form#new_account');
      var $latitude = $form.find("input[name*='[location_attributes][latitude]']");
      var $longitude = $form.find("input[name*='[location_attributes][longitude]']");
      var $full_street_address = $form.find("input[name*='[location_attributes][full_street_address]']");
      var $city = $form.find("input[name*='[location_attributes][city]']");
      var $state = $form.find("input[name*='[location_attributes][state]']");
      var $state_code = $form.find("input[name*='[location_attributes][state_code]']");
      var $postal_code = $form.find("input[name*='[location_attributes][postal_code]']");
      var $country = $form.find("input[name*='[location_attributes][country]']");
      var $country_code = $form.find("input[name*='[location_attributes][country_code]']");
      var $url = $form.find("input[name*='[location_attributes][url]']");
      var $address = $form.find('#address');

      $url.val(place.url);
      $latitude.val(place.geometry.location.lat());
      $longitude.val(place.geometry.location.lng());
      $full_street_address.val(place.formatted_address);
      var city = R.find(R.where({types: R.contains('locality')}), place.address_components);
      city = city || R.find(R.where({types: R.contains('sublocality')}), place.address_components);
      $city.val(city.long_name);
      var state = R.find(R.where({types: R.contains('administrative_area_level_1')}), place.address_components);
      $state.val(state.long_name);
      $state_code.val(state.short_name);
      var postal_code = R.find(R.where({types: R.contains('postal_code')}), place.address_components);
      $postal_code.val(postal_code.short_name);
      var country = R.find(R.where({types: R.contains('country')}), place.address_components);
      $country.val(country.long_name);
      $country_code.val(country.short_name);
      var address = R.reject(R.isEmpty, [place.name, city.long_name, state.short_name, postal_code.short_name]).join(', ');
      $address.val(address);
      input.data('address', address);
      var $locationSearch = $('#location-search');
      $locationSearch.removeClass('has-warning');
      $locationSearch.find('.form-control-feedback').remove();
      var $teamName = $form.find("#account_organization_attributes_teams_attributes_0_name");
      $teamName.val(city.long_name);
    });

    function missingLocation(input) {
      return R.or(input.data('address') !== input.val(), R.any(function(field) {
        return $(field).val() === "";
      }, $("#new_account input[name*='account'][name*='location']")));
    }

    function validateLocation(e) {
      var $locationSearch = $('#location-search');
      var input = $locationSearch.find('input');
      if (input.val() && missingLocation(input)) {
        e.preventDefault();
        $locationSearch.addClass('has-warning');
        $locationSearch.find('.form-control-feedback').remove();
        $locationSearch.append('<div class="form-control-feedback">Oops! We need a full street address.</div><div class="form-control-feedback">Please enter a full street address and select from the dropdown.</div>');
      }
    }

    $(document).on('focusout', input, validateLocation);
    $(document).on('click', '#new_account button[type="submit"]', validateLocation);

    google.maps.event.addDomListener(input[0], 'keydown', function(e){
      var keyCode = e.keyCode || e.which;
      var noneSelected = $('.pac-item-selected').length === 0;
      var isTabOrEnter = keyCode === 13 || keyCode === 9;
      var isSearching = isTabOrEnter && noneSelected && !e.triggered;

      if(isSearching) {
        e.preventDefault();
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 40 });
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 13, triggered: true });
      }
    });

    input.attr('loaded', true);
  }
}

function initTeamSearch() {
  var input = $('#team-search input:not([loaded])');
  if(input.length && typeof google !== "undefined") {
    var options = {
      componentRestrictions: { country: 'us' },
      types: ['address']
    };

    var autocomplete = new google.maps.places.Autocomplete(input[0], options);
    autocomplete.addListener('place_changed', function() {
      var place = autocomplete.getPlace();
      var $form = $('form#new_team');
      var $latitude = $form.find("input[name*='[location_attributes][latitude]']");
      var $longitude = $form.find("input[name*='[location_attributes][longitude]']");
      var $full_street_address = $form.find("input[name*='[location_attributes][full_street_address]']");
      var $city = $form.find("input[name*='[location_attributes][city]']");
      var $state = $form.find("input[name*='[location_attributes][state]']");
      var $state_code = $form.find("input[name*='[location_attributes][state_code]']");
      var $postal_code = $form.find("input[name*='[location_attributes][postal_code]']");
      var $country = $form.find("input[name*='[location_attributes][country]']");
      var $country_code = $form.find("input[name*='[location_attributes][country_code]']");
      var $url = $form.find("input[name*='[location_attributes][url]']");
      var $address = $form.find('#address');

      $url.val(place.url);
      $latitude.val(place.geometry.location.lat());
      $longitude.val(place.geometry.location.lng());
      $full_street_address.val(place.formatted_address);
      var city = R.find(R.where({types: R.contains('locality')}), place.address_components);
      city = city || R.find(R.where({types: R.contains('sublocality')}), place.address_components);
      $city.val(city.long_name);
      var state = R.find(R.where({types: R.contains('administrative_area_level_1')}), place.address_components);
      $state.val(state.long_name);
      $state_code.val(state.short_name);
      var postal_code = R.find(R.where({types: R.contains('postal_code')}), place.address_components);
      $postal_code.val(postal_code.short_name);
      var country = R.find(R.where({types: R.contains('country')}), place.address_components);
      $country.val(country.long_name);
      $country_code.val(country.short_name);
      var address = R.reject(R.isEmpty, [place.name, city.long_name, state.short_name, postal_code.short_name]).join(', ');
      $address.val(address);
      input.data('address', address);
      var $teamSearch = $('#team-search');
      $teamSearch.removeClass('has-warning');
      $teamSearch.find('.form-control-feedback').remove();
    });

    function missingLocation(input) {
      return R.or(input.data('address') !== input.val(), R.any(function(field) {
        return $(field).val() === "";
      }, $("#new_team input[name*='team'][name*='location']")));
    }

    function validateLocation(e) {
      var $teamSearch = $('#team-search');
      var input = $teamSearch.find('#address');
      if (input.val() && missingLocation(input)) {

        e.preventDefault();
        $teamSearch.addClass('has-warning');
        $teamSearch.find('.form-control-feedback').remove();
        $teamSearch.append('<div class="form-control-feedback">Oops! We need a full street address.</div><div class="form-control-feedback">Please enter a full street address and select from the dropdown.</div>');
      }
    }

    $(document).on('focusout', input, validateLocation);
    $(document).on('click', '#new_team input[type="submit"]', validateLocation);

    google.maps.event.addDomListener(input[0], 'keydown', function(e){
      var keyCode = e.keyCode || e.which;
      var noneSelected = $('.pac-item-selected').length === 0;
      var isTabOrEnter = keyCode === 13 || keyCode === 9;
      var isSearching = isTabOrEnter && noneSelected && !e.triggered;

      if(isSearching) {
        e.preventDefault();
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 40 });
        google.maps.event.trigger(input[0], 'keydown', { keyCode: 13, triggered: true });
      }
    });

    input.attr('loaded', true);
  }
}

function initAutocompletes() {
  // Timing issues cause FF and IE to need the functions loaded immediately.
  // Chrome loads them after the ready event.
  initAccountSearch();
  initTeamSearch();

  $(function() {
    initAccountSearch();
    initTeamSearch();
  });
}
