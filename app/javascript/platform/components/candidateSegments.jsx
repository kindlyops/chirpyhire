import React from 'react'

import CandidateSegment from './candidateSegment'

const CandidateSegments = props => (
  <div className='CandidateSegments pl-3'>
    <CandidateSegment name='All' />
    <CandidateSegment name='Active' />
    <CandidateSegment name='Slipping Away' />
  </div>
)

export default CandidateSegments
