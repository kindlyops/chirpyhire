import React from 'react'

import Candidates from './components/candidates'
import update from 'immutability-helper'
import _ from 'lodash'

class Segment extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      total_count: 0,
      contact_total_count: 0,
      current_page: 1,
      total_pages: 1,
      form: { page: 1 },
      candidates: []
    }

    this.onPageChange = this.onPageChange.bind(this);
    this.updatePredicates = this.updatePredicates.bind(this);
    this.exportCSV = this.exportCSV.bind(this);
    this.searchCandidates = this.searchCandidates.bind(this);
    this.updateCandidate = this.updateCandidate.bind(this);
  }

  render() {
    return (
      <Candidates
        {...this.props}
        total_count={this.state.total_count}
        contact_total_count={this.state.contact_total_count}
        current_page={this.state.current_page}
        total_pages={this.state.total_pages}
        form={this.state.form}
        candidates={this.state.candidates}
        searchCandidates={this.searchCandidates}
        onPageChange={this.onPageChange}
        updatePredicates={this.updatePredicates}
        updateCandidate={this.updateCandidate}
        exportCSV={this.exportCSV}
      />
    )
  }

  componentDidMount() {
    let segment = this.props.fetch(this.id());
    let newState = R.mergeAll([{}, this.state, segment]);
    this.setState(newState, this.searchCandidates);
  }

  componentDidUpdate(prevProps, prevState) {
    let prevId = prevProps.match.params.id;
    let currentId = this.props.match.params.id;

    if(prevId === currentId) {
      let prevForm = prevState.form;
      let currentForm = this.state.form;

      if(!R.equals(prevForm, currentForm)) {
        this.searchCandidates();
      }
    } else {
      let segment = this.props.fetch(currentId);
      let newState = R.mergeAll([{}, this.state, segment]);
      this.setState(newState);
    }
  }

  updateCandidate(candidate) {
    let candidates = this.state.candidates;
    let candidateIndex = _.findIndex(candidates, { 'id': candidate.id });

    let newCandidates = update(candidates, {
      $splice: [[candidateIndex, 1, candidate]]
    });
    this.setState({ candidates: newCandidates });
  }

  searchCandidates() {
    return $.ajax(this.ajaxConfig(this.searchUrl(), 'json')).then(search => {
      let newState = R.mergeAll([{}, this.state, search]);
      this.setState(newState);
    });
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

  id() {
    return this.props.match.params.id;
  }

  onPageChange(page) {
    let newState = update(this.state, { form: { page: { $set: page }}});
    this.setState(newState);
  }

  isSelected() {
    return _.some(this.state.candidates, { 'selected': true });
  }

  selected() {
    if (this.isSelected()) {
      return _.filter(this.state.candidates, { 'selected': true });
    } else {
      return this.state.candidates;
    }
  }

  ajaxConfig(url, dataType) {
    var form = this.state.form;

    if (this.isSelected()) {
      if(!form.predicates) {
        form.predicates = [];
      }
      form.predicates.push({
        type: 'integer', attribute: 'id',
        value: _.map(this.selected(), 'id'), comparison: 'in'
      })
    } else {
      let predicates = _.filter(form.predicates, p => (p.comparison !== 'in' && p.attribute !== 'id'));
      form.predicates = predicates;
    }

    return {
      url: url,
      data: JSON.stringify(form),
      type: 'POST',
      method: 'POST',
      dataType: dataType,
      contentType: 'application/json'
    }
  }

  exportCSV() {
    $.ajax(this.ajaxConfig('/candidates/search.csv', 'text')).then(data => {
      let filename = `candidates-${Date.now()}.csv`;
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
}

export default Segment
