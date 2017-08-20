import React from 'react'
import Geosuggest from 'react-geosuggest'
import locationParser from '../services/locationParser'

class LocationCandidateFilter extends React.Component {
  constructor(props) {
    super(props);

    this.handleLocationChange = this.handleLocationChange.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    let nextValue = this.value(nextProps.form);
    if (nextValue && this._geoSuggest) {
      this._geoSuggest.update(nextValue);
    }
  }

  handleLocationChange(suggest) {
    this.props.handleLocationChange(locationParser(suggest));
  }

  predicate() {
    if (this.isChecked()) {
      return (
        <div className='predicate'>
          <div className='predicate-inner'>
            <Geosuggest
              ref={el=>this._geoSuggest=el}
              placeholder='Search' 
              types={['(regions)']}
              country={'us'}
              highlightMatch={false}
              value={this.value(this.props.form)}
              autoActivateFirstSuggest={true}
              onSuggestSelect={this.handleLocationChange}
             />
          </div>
        </div>
      )
    }
  }

  value(form) {
    if(this.locationPresent(form)) {
      const { zipcode_default_city_eq, zipcode_state_abbreviation_eq, zipcode_county_name_eq, zipcode_zipcode_eq } = form.q;
      return R.reject(R.isNil, [zipcode_default_city_eq, zipcode_county_name_eq, zipcode_state_abbreviation_eq, zipcode_zipcode_eq]).join(', ');
    } else {
      return '';
    }
  }

  locationPresent(form) {
    let isPresent = key => form.q && !!form.q[`zipcode_${key}_eq`];
    return R.any(isPresent, ['default_city', 'zipcode', 'county_name', 'state_abbreviation']);
  }

  isChecked() {
    return this.locationPresent(this.props.form) || this.props.checked;
  }

  name() {
    return this.props.attribute.toLowerCase();
  }

  render() {
    return (
      <div className='CandidateFilter CandidateFilter--location'>
        <div className='form-check small-uppercase'>
          <label className='form-check-label'>
            <input onChange={this.props.toggleLocation} name={this.name()} className='form-check-input' type="checkbox" value="" checked={this.isChecked()} />
            <i className={`fa fa-fw mr-1 ml-1 ${this.props.icon}`}></i>
            {` ${this.props.attribute}`}
          </label>
        </div>
        {this.predicate()}
      </div>
    )
  }
}

export default LocationCandidateFilter
