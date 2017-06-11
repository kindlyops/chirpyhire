import React from 'react'

import CandidateFilter from './candidateFilter'

const CandidateFilters = props => (
  <div className='CandidateFilters'>
    <div className='CandidateFiltersHeader'>
      <h3>Caregiver Attributes</h3>
    </div>
    <CandidateFilter attribute='Location' />
    <CandidateFilter attribute='Starred' />
    <CandidateFilter attribute='Certification' />
    <CandidateFilter attribute='Availability' />
    <CandidateFilter attribute='Experience' />
    <CandidateFilter attribute='Transportation' />
  </div>
)

export default CandidateFilters
