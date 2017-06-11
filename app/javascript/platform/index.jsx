import React from 'react'

import CandidateSegments from './components/candidateSegments'
import Candidates from './components/candidates'

const Platform = props => (
  <div className='Platform'>
    <CandidateSegments />
    <Candidates />
  </div>
)

export default Platform
