import React from 'react'

import CandidateFilter from './candidateFilter'

const CandidateFilters = props => (
  <div>
    <CandidateFilter attribute='Location' />
    <CandidateFilter attribute='Starred' />
    <CandidateFilter attribute='Certification' />
    <CandidateFilter attribute='Availability' />
    <CandidateFilter attribute='Experience' />
    <CandidateFilter attribute='Transportation' />
  </div>
)

export default CandidateFilters
