import React from 'react'

import CandidatesMenu from './candidatesMenu'
import CandidatesTable from './candidatesTable'
import Pagination from '../../shared/pagination'

const CandidatesListContainer = props => (
  <div className='CandidatesListContainer'>
    <CandidatesMenu total_count={props.total_count} />
    <CandidatesTable {...props} />
    <Pagination 
      current_page={props.current_page} 
      total_count={props.total_count}
      total_pages={props.total_pages}
      />
  </div>
)

export default CandidatesListContainer
