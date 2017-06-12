import React from 'react'

import CandidateFilters from './candidateFilters'
import CandidatesListContainer from './candidatesListContainer'

const Candidates = props => (
  <div className='Candidates'>
    <CandidateFilters />
    <CandidatesListContainer />
  </div>
)

export default Candidates
