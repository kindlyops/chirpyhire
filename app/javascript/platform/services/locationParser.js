export default function locationParser(suggest) {
  let place = suggest.gmaps;
  if (place && place.types) {
    let isZipcode = R.contains("postal_code", place.types);
    let isState = R.contains("administrative_area_level_1", place.types);
    let isCounty = R.contains("administrative_area_level_2", place.types);
    let isCity = R.contains("locality", place.types) || R.contains("sublocality", place.types);
    let stateComponent = R.find(R.where({types: R.contains('administrative_area_level_1')}), place.address_components);
    let countyComponent = R.find(R.where({types: R.contains('administrative_area_level_2')}), place.address_components);
    let zipcodeComponent = R.find(R.where({types: R.contains('postal_code')}), place.address_components);
    let cityComponent = R.find(R.where({types: R.contains('locality')}), place.address_components) || R.find(R.where({types: R.contains('sublocality')}), place.address_components);
    
    if (isZipcode) {
      return {
        zipcode: zipcodeComponent.short_name
      };
    } else if (isState) {
      return {
        state_abbreviation: stateComponent.short_name
      }
    } else if (isCounty) {
      return {
        county_name: countyComponent.long_name.replace(/ County/, ""),
        state_abbreviation: stateComponent.short_name
      }
    } else if (isCity) {
      return {
        default_city: cityComponent.long_name,
        state_abbreviation: stateComponent.short_name
      }
    } else {
      return {};
    }
  }
}
