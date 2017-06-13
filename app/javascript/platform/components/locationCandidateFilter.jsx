import React from 'react'
import Geosuggest from 'react-geosuggest'

const LocationCandidateFilter = props => (
  <div className='CandidateFilter CandidateFilter--location'>
    <div className='form-check small-caps'>
      <label className='form-check-label'>
        <input className='form-check-input' type="checkbox" value="" />
        <i className={`fa fa-fw mr-1 ml-1 ${props.icon}`}></i>
        {` ${props.attribute}`}
      </label>
    </div>

    <div className='predicate'>
      <div className='predicate-buttons'>
        <span className='close-predicate'>
          <i className='fa fa-times'></i>
        </span>
      </div>

      <div className='predicate-inner'>
        <Geosuggest placeholder='Search' />
        <div className='spacer-10'></div>
      </div>
    </div>
  </div>
)

export default LocationCandidateFilter
