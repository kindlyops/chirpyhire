import React from 'react'

import Candidates from './components/candidates'
import CandidateSegments from './components/candidateSegments'
import queryString from 'query-string'
import update from 'immutability-helper'
import RestartNotificationBar from '../restart_notification_bar'

class Platform extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      candidates: [],
      total_count: 0,
      contact_total_count: 0,
      current_page: 1,
      total_pages: 1,
      segments: [{
        id: 'all',
        name: 'All',
        form: {}
      }],
      form: R.merge({ page: 1 }, queryString.parse(this.props.location.search, { arrayFormat: 'bracket' }))
    }

    this.handlePageChange = this.handlePageChange.bind(this);
    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.handleTextChange = this.handleTextChange.bind(this);
    this.handleNumberChange = this.handleTextChange;
    this.handleLocationChange = this.handleLocationChange.bind(this);
    this.handleSegmentChange = this.handleSegmentChange.bind(this);
    this.handleSegment = this.handleSegment.bind(this);
    this.exportCSV = this.exportCSV.bind(this);
  }

  render() {
    return (
      <div className='Platform ch--Page'>
        <RestartNotificationBar {...this.props} />
        <div className='ch--Header'>
          <h1>Caregivers</h1>
        </div>
        <CandidateSegments segments={this.state.segments} handleSegmentChange={this.handleSegmentChange} />
        <Candidates 
          {...this.state}
          {...this.props}
          handleSegment={this.handleSegment}
          handlePageChange={this.handlePageChange}
          handleSelectChange={this.handleSelectChange}
          handleTextChange={this.handleTextChange}
          handleNumberChange={this.handleNumberChange}
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
    const newState = R.mergeAll([{}, this.state, {
      form: newForm
    }]);
    this.setState(newState);
  }

  handleTextChange(event) {
    const filter = event.target.name;
    const value = event.target.value;
    let newForm = update(this.state.form, { [filter]: { $set: value }});
    newForm.page = 1;
    const newState = R.mergeAll([{}, this.state, {
      form: newForm
    }]);
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
      let newState = R.mergeAll([{}, this.state, data]);
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
