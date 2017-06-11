import React from 'react'

import CandidateFilter from './candidateFilter'

const CandidateFilters = props => (
  <form className='CandidateFilters'>
    <div className='CandidateFiltersHeader'>
      <h3 className='small-caps'>Candidate Attributes</h3>
    </div>
    <CandidateFilter icon='fa-map-marker' attribute='Location' />
    <CandidateFilter icon='fa-star' attribute='Starred' />
    <CandidateFilter icon='fa-graduation-cap' attribute='Certification' />
    <CandidateFilter icon='fa-calendar-check-o' attribute='Availability' />
    <CandidateFilter icon='fa-level-up' attribute='Experience' />
    <CandidateFilter icon='fa-road' attribute='Transportation' />
  </form>
)

export default CandidateFilters
