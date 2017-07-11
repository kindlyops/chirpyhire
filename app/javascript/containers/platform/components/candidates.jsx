import React from 'react'

import CandidateFilters from './candidateFilters'
import CandidatesListContainer from './candidatesListContainer'
import Main from '../../../components/main'

class Candidates extends React.Component {
  empty() {
    return (
      <div className='empty-candidates'>
        <h3 className='text-muted'>No caregivers found...</h3>
        <blockquote className='blockquote'>
          <p className='mb-0'>If you can dream it</p>
          <p className='mb-0'>you can do it</p>
          <footer className='mt-3 blockquote-footer'>Walt Disney</footer>
        </blockquote>
      </div>
    )
  }

  list() {
    return (
      <CandidatesListContainer {...this.props} />
    )
  }

  render() {
    let body;
    if(this.props.candidates.length) {
      body = this.list()
    } else {
      body = this.empty()
    }

    return (
      <Main className='Candidates'>
        <CandidateFilters {...this.props} />
        {body}
      </Main>
    )
  }
}

export default Candidates
