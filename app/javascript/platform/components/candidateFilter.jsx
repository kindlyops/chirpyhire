import React from 'react'

const CandidateFilter = props => (
  <div className='form-check small-caps'>
    <label className='form-check-label'>
      <input className='form-check-input' type="checkbox" value="" />
      <i className={`fa fa-fw mr-1 ml-1 ${props.icon}`}></i>
      {` ${props.attribute}`}
    </label>
  </div>
)

export default CandidateFilter
