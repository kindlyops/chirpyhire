import React from 'react'

import Candidates from './components/candidates'
import CandidateSegments from './components/candidateSegments'
import queryString from 'query-string'
import update from 'immutability-helper'

class Platform extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      candidates: [],
      total_count: 0,
      current_page: 1,
      total_pages: 1,
      segments: [{
        id: 'all',
        name: 'All',
        form: {}
      }],
      form: Object.assign({ page: 1 }, queryString.parse(this.props.location.search, { arrayFormat: 'bracket' }))
    }

    this.handlePageChange = this.handlePageChange.bind(this);
    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.handleStarChange = this.handleStarChange.bind(this);
    this.handleLocationChange = this.handleLocationChange.bind(this);
    this.handleSegmentChange = this.handleSegmentChange.bind(this);
    this.handleSegment = this.handleSegment.bind(this);
    this.exportCSV = this.exportCSV.bind(this);
  }

  render() {
    return (
      <div className='Platform'>
        <div className='PlatformHeader'>
          <h1>Caregivers</h1>
        </div>
        <CandidateSegments segments={this.state.segments} handleSegmentChange={this.handleSegmentChange} />
        <Candidates 
          {...this.state}
          inboxId={this.props.current_account.inbox.id}
          handleSegment={this.handleSegment}
          handlePageChange={this.handlePageChange}
          handleSelectChange={this.handleSelectChange}
          handleStarChange={this.handleStarChange}
          handleLocationChange={this.handleLocationChange}
          exportCSV={this.exportCSV}
        />
      </div>
    )
  }

  handleSegmentChange(form) {
    form.page = 1;
    let newState = update(this.state, { form: { $set: form } });
    this.setState(newState)
  }

  handleSegment(segment) {
    const index = R.findIndex((s) => (s.id === segment.id), this.state.segments);
    let newState;
    if (index !== -1) {
      newState = update(this.state, { segments: { $splice: [[index, 1, segment]] }});
    } else {
      newState = update(this.state, { segments: { $push: [segment] }});
    }

    this.setState(newState); 
  }

  handleLocationChange(location) {
    let newForm = update(this.state.form, { $unset: ['zipcode', 'city', 'state', 'county'] });
    newForm = update(newForm, { $merge: location });
    newForm.page = 1;
    const newState = update(this.state, { form: { $set: newForm } });
    this.setState(newState);
  }

  handleSelectChange(selectedOption) {
    const filter = selectedOption.filter;
    let newForm;
    if(selectedOption.value && selectedOption.value.length) {
      newForm = update(this.state.form, { [filter]: {
        $set: selectedOption.value
      }});
    } else {
      newForm = update(this.state.form, { $unset: [`${filter}`]});
    }
    newForm.page = 1;
    const newState = Object.assign({}, this.state, {
      form: newForm
    });
    this.setState(newState);
  }

  handleStarChange(event) {
    const filter = event.target.name;
    const isChecked = event.target.checked;
    let newForm;
    if(isChecked) {
      newForm = update(this.state.form, { [filter]: {
        $set: true
      }});
    } else {
      newForm = update(this.state.form, { $unset: [`${filter}`]});
    }
    newForm.page = 1;
    const newState = Object.assign({}, this.state, {
      form: newForm
    });
    this.setState(newState);
  }

  exportCSV() {
    window.location.href = '/candidates.csv' + this.props.location.search;
  }

  componentDidUpdate(prevProps, prevState) {
    let prevForm = prevState.form;
    let currentForm = this.state.form;
    if(!R.equals(prevForm, currentForm)) {
      this.updateCandidates();
    }
  }

  updateCandidates() {
    let stringifyForm = queryString.stringify(
                          this.state.form, { arrayFormat: 'bracket' }
                        );

    let search = `?${stringifyForm}`;
    let path = `${this.props.location.pathname}${search}`;

    this.props.history.push(path);
    this.fetchCandidates(search);
  }

  handlePageChange(page) {
    let newState = update(this.state, { form: { page: { $set: page }}});
    this.setState(newState);
  }

  candidatesUrl(search) {
    return `/candidates.json${search}`;
  }

  fetchCandidates(search) {
    return $.get(this.candidatesUrl(search)).then(data => {
      let newState = Object.assign({}, this.state, data);
      this.setState(newState);
    });
  }

  fetchSegments() {
    $.get('/segments').then((segments) => {
      let newState = update(this.state, { segments: { $push: segments }});
      this.setState(newState); 
    });
  }

  componentDidMount() {
    this.fetchSegments();
    this.fetchCandidates(this.props.location.search);
  }
}

export default Platform
