import React from 'react'

import CandidateSegments from './components/candidateSegments'
import Candidates from './components/candidates'

class Platform extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      candidates: [],
      total_count: 0,
      current_page: 1,
      total_pages: 1
    }
  }

  render() {
    return (
      <div className='Platform'>
        <div className='PlatformHeader'>
          <h1>Caregivers</h1>
        </div>
        <CandidateSegments />
        <Candidates {...this.state} />
      </div>
    )
  }

  componentDidMount() {
    $.get('/candidates/search').then((response) => (
      this.setState(response)
    ));
  }
}

export default Platform
