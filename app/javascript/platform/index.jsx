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

    this.handlePageChange = this.handlePageChange.bind(this);
  }

  render() {
    return (
      <div className='Platform'>
        <div className='PlatformHeader'>
          <h1>Caregivers</h1>
        </div>
        <CandidateSegments />
        <Candidates {...this.state} handlePageChange={this.handlePageChange} />
      </div>
    )
  }

  handlePageChange(current_page) {
    this.candidates(current_page);
  }

  candidatesUrl(page = 1) {
    return `/candidates/search?page=${page}`;
  }

  candidates(page = 1) {
    return $.get(this.candidatesUrl(page)).then((candidates) => (
      this.setState(candidates)
    ));
  }

  componentDidMount() {
    this.candidates();
  }
}

export default Platform
