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
      const { city, state, county, zipcode } = form;
      return R.reject(R.isNil, [city, county, state, zipcode]).join(', ');
    } else {
      return ''
    }
  }

  locationPresent(form) {
    let isPresent = key => !!form[key];
    return R.any(isPresent, ['city', 'zipcode', 'county', 'state']);
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
        <div className='form-check small-caps'>
          <label className='form-check-label'>
            <input onChange={this.props.toggle} name={this.name()} className='form-check-input' type="checkbox" value="" checked={this.isChecked()} />
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
