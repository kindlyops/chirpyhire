import React from 'react'

import CandidateFilters from './candidateFilters'
import CandidatesListContainer from './candidatesListContainer'

class Candidates extends React.Component {
  render() {
    return (
      <div className='Candidates ch--main'>
        <CandidateFilters {...this.props} />
        <CandidatesListContainer {...this.props} />
      </div>
    )
  }
}

export default Candidates
