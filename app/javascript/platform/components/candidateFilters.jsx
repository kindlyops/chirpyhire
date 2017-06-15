import React from 'react'

import CandidateFilter from './candidateFilter'
import LocationCandidateFilter from './locationCandidateFilter'
import StarredCandidateFilter from './starredCandidateFilter'
import CandidateFiltersActions from './candidateFiltersActions'
import configuration from '../configuration/segments'
import update from 'immutability-helper'

class CandidateFilters extends React.Component {
  constructor(props) {
    super(props);
    this.state = configuration;
    this.toggle = this.toggle.bind(this);
    this.handleSelectChange = this.handleSelectChange.bind(this);
    this.handleStarChange = this.handleStarChange.bind(this);
    this.handleLocationChange = this.handleLocationChange.bind(this);
  }

  toggle(event) {
    const filter = event.target.name;
    const newFilter = update(this.state[filter], {
      checked: {
        $set: event.target.checked
      }
    });
    const newForm = update(this.state.form, {
      $unset: [`${filter}`]
    });
    const newState = Object.assign({}, this.state, {
      [filter]: newFilter,
      form: newForm
    });

    this.setState(newState);
  }

  handleLocationChange(location) {
    let newForm = update(this.state.form, { $unset: ['zipcode', 'city', 'state', 'county'] });
    newForm = update(newForm, { $merge: location });
    const newState = update(this.state, { form: { $set: newForm } });
    this.setState(newState);
  }

  handleSelectChange(selectedOption) {
    const filter = selectedOption.filter;
    const newForm = update(this.state.form, { [filter]: {
      $set: selectedOption.value
    }});
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
    const newState = Object.assign({}, this.state, {
      form: newForm
    });
    this.setState(newState);
  }

  render() {
    return (
      <form className='CandidateFilters'>
        <div className='CandidateFilters--inner'>
          <div className='CandidateFiltersHeader'>
            <h3 className='small-caps'>Candidate Attributes</h3>
          </div>
          <LocationCandidateFilter 
            handleLocationChange={this.handleLocationChange}
            toggle={this.toggle}
            form={this.state.form}
            {...this.state.location} />
          <StarredCandidateFilter 
            handleStarChange={this.handleStarChange}
            form={this.state.form}
            {...this.state.starred} />
          <CandidateFilter 
            handleSelectChange={this.handleSelectChange}
            toggle={this.toggle}
            form={this.state.form}
            {...this.state.certification} />
          <CandidateFilter 
            handleSelectChange={this.handleSelectChange}
            toggle={this.toggle}
            form={this.state.form}
            {...this.state.availability} />
          <CandidateFilter 
            handleSelectChange={this.handleSelectChange}
            toggle={this.toggle}
            form={this.state.form}
            {...this.state.experience} />
          <CandidateFilter 
            handleSelectChange={this.handleSelectChange}
            toggle={this.toggle}
            form={this.state.form}
            {...this.state.transportation} />
        </div>
        <CandidateFiltersActions />
      </form>
    )
  }
}

export default CandidateFilters
