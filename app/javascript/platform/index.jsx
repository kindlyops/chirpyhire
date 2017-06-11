import React from 'react'

import CandidateSegments from './components/candidateSegments'
import Candidates from './components/candidates'

const Platform = props => (
  <div className='Platform'>
    <div className='PlatformHeader'>
      <h1>Caregivers</h1>
    </div>
    <CandidateSegments />
    <Candidates />
  </div>
)

export default Platform
