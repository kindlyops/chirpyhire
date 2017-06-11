import React from 'react'
import Select from 'react-select'

const StarredCandidateFilter = props => (
  <div className='CandidateFilter CandidateFilter--starred'>
    <div className='form-check small-caps'>
      <label className='form-check-label'>
        <input className='form-check-input' type="checkbox" value="" />
        <i className={`fa fa-fw mr-1 ml-1 ${props.icon}`}></i>
        {` ${props.attribute}`}
      </label>
    </div>
  </div>
)

export default StarredCandidateFilter
