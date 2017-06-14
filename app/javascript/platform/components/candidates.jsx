import React from 'react'

import CandidateFilters from './candidateFilters'
import CandidatesListContainer from './candidatesListContainer'

const Candidates = props => (
  <div className='Candidates'>
    <CandidateFilters />
    <CandidatesListContainer {...props} />
  </div>
)

export default Candidates
