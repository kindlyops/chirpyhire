import React from 'react'

import Candidates from './components/candidates'

class Segment extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      candidates: [],
      total_count: 0,
      contact_total_count: 0,
      current_page: 1,
      total_pages: 1,
      form: { page: 1 }
    }

    this.handlePageChange = this.handlePageChange.bind(this);
    this.handleSegment = this.handleSegment.bind(this);
    this.searchCandidates = this.searchCandidates.bind(this);
    this.updatePredicates = this.updatePredicates.bind(this);
    this.exportCSV = this.exportCSV.bind(this);
  }

  render() {
    return (
      <Candidates
        {...this.state}
        {...this.props}
        searchCandidates={this.searchCandidates}
        handleSegment={this.handleSegment}
        handlePageChange={this.handlePageChange}
        updatePredicates={this.updatePredicates}
        exportCSV={this.exportCSV}
      />
    )
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

  searchUrl() {
    return `/candidates/search.json`;
  }

  searchCandidates() {
    const config = {
      url: this.searchUrl(),
      data: JSON.stringify(this.state.form),
      type: 'POST',
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json'
    }

    return $.ajax(config).then(data => {
      let newState = R.mergeAll([{}, this.state, data]);
      this.setState(newState);
    });
  }

  componentDidMount() {
    this.searchCandidates();
  }

  updatePredicates(attribute, predicates) {
    let newPredicates = this.state.form.predicates || [];
    
    newPredicates = _.filter(newPredicates, (predicate) => {
      return predicate.attribute !== attribute
    });

    newPredicates = newPredicates.concat(predicates);
    let newForm = update(this.state.form, {
      predicates: { $set: newPredicates }
    });

    this.setState({ form: newForm });
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
}

export default Segment
