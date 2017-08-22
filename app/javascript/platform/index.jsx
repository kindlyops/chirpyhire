import React from 'react'

import Candidates from './components/candidates'
import CandidateSegments from './components/candidateSegments'
import update from 'immutability-helper'
import RestartNotificationBar from '../restart_notification_bar'

class Platform extends React.Component {
  constructor(props) {
    let mock = [{type: "date", attribute: "last_reply_at", comparison: "lt", value: "30"},
                {type: "date", attribute: "last_reply_at", comparison: "gt", value: "60"},
                {type: "integer", attribute: "messages_count", comparison: "gt", value: "5"}]

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
      form: { page: 1, predicates: mock }
    }

    this.handlePageChange = this.handlePageChange.bind(this);
    this.handleSegmentChange = this.handleSegmentChange.bind(this);
    this.handleSegment = this.handleSegment.bind(this);
    this.searchCandidates = this.searchCandidates.bind(this);
    this.removePredicates = this.removePredicates.bind(this);
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
          searchCandidates={this.searchCandidates}
          handleSegment={this.handleSegment}
          handlePageChange={this.handlePageChange}
          removePredicates={this.removePredicates}
          exportCSV={this.exportCSV}
        />
      </div>
    )
  }

  removePredicates(predicates) {
    if(!this.state.form.predicates) return;

    let newForm = this.state.form;
    _.each(predicates, (predicate) => {
      let index = _.findIndex(this.state.form.predicates, (fp) => {
        return fp.id === predicate.id;
      });

      newForm = update(this.state.form, {
        predicates: { $splice: [[index]] }
      });
    });

    this.setState({ form: newForm });
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

  exportCSV() {
    $.post('/candidates/search.csv', this.state.form).then(data => {
      let filename = `caregivers-${Date.now()}.csv`;
      let csv = new Blob([data], { type: 'text/csv;charset=utf-8' });

      if (navigator.msSaveBlob) {
          navigator.msSaveBlob(csv, filename);
      } else {
          var link = document.createElement('a');
          link.href = window.URL.createObjectURL(csv);
          link.setAttribute('download', filename);
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
      }
    });
  }

  componentDidUpdate(prevProps, prevState) {
    let prevForm = prevState.form;
    let currentForm = this.state.form;
    if(!R.equals(prevForm, currentForm)) {
      this.searchCandidates();
    }
  }

  handlePageChange(page) {
    let newState = update(this.state, { form: { page: { $set: page }}});
    this.setState(newState);
  }

  searchUrl() {
    return `/candidates/search.json`;
  }

  searchCandidates() {
    return $.post(this.searchUrl(), this.state.form).then(data => {
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
    this.searchCandidates();
  }
}

export default Platform
