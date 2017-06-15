import React from 'react'

import CandidateSegments from './components/candidateSegments'
import Candidates from './components/candidates'
import queryString from 'query-string'

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

  handlePageChange(page) {
    let searchParams = queryString.parse(this.props.location.search);
    searchParams.page = page;
    let search = queryString.stringify(searchParams);
    let path = `${this.props.location.pathname}?${search}`;
    this.props.history.push(path);
  }

  candidatesUrl(page = 1) {
    return `/candidates.json?page=${page}`;
  }

  fetchCandidates(search) {
    const { page = 1 } = queryString.parse(search);

    return $.get(this.candidatesUrl(page)).then(data => {
      this.setState(data);
    });
  }

  componentDidMount() {
    this.fetchCandidates(this.props.location.search);
  }

  componentWillUpdate(nextProps) {
    let currentSearchParams = queryString.parse(this.props.location.search);
    let newSearchParams = queryString.parse(nextProps.location.search);

    if(!R.equals(currentSearchParams, newSearchParams)) {
      this.fetchCandidates(nextProps.location.search);
    }
  }
}

export default Platform
