import React from 'react'

import CandidatesMenu from './candidatesMenu'
import CandidatesTable from './candidatesTable'

const CandidatesListContainer = props => (
  <div className='CandidatesListContainer'>
    <CandidatesMenu />
    <CandidatesTable />
  </div>
)

export default CandidatesListContainer
