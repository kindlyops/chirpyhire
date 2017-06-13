import React from 'react'

const CandidatesMenu = props => (
  <div className='CandidatesMenu'>
    <div className='CandidatesMenu--left'>
      <h2 className='CandidatesCount'>12 candidates</h2>
    </div>
    <div className='CandidatesMenu--right'>
      <button className='btn btn-sm btn-primary export-caregivers' role="button">
        Export
        <i className='fa fa-cloud-download ml-2'></i>
      </button>
    </div>
  </div>
)

export default CandidatesMenu
