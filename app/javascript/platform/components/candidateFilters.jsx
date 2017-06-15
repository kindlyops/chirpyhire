import React from 'react'

import CandidateFilter from './candidateFilter'
import LocationCandidateFilter from './locationCandidateFilter'
import StarredCandidateFilter from './starredCandidateFilter'
import configuration from '../configuration/segments'
import update from 'immutability-helper'

class CandidateFilters extends React.Component {
  constructor(props) {
    super(props);
    this.state = configuration;
    this.toggle = this.toggle.bind(this);
    this.toggleLocation = this.toggleLocation.bind(this);
  }

  toggleLocation(event) {
    const newState = update(this.state, { location: {
      checked: {
        $set: event.target.checked
      }
    }});
    this.setState(newState);
    this.props.handleLocationChange({});
  }

  toggle(event) {
    const filter = event.target.name;
    const newFilter = update(this.state[filter], {
      checked: {
        $set: event.target.checked
      }
    });
    const newState = Object.assign({}, this.state, {
      [filter]: newFilter
    });

    this.props.handleSelectChange({ filter: filter, value: null });
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
            handleLocationChange={this.props.handleLocationChange}
            toggleLocation={this.toggleLocation}
            form={this.props.form}
            {...this.state.location} />
          <StarredCandidateFilter 
            handleStarChange={this.props.handleStarChange}
            form={this.props.form}
            {...this.state.starred} />
          <CandidateFilter 
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.certification} />
          <CandidateFilter 
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.availability} />
          <CandidateFilter 
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.experience} />
          <CandidateFilter 
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.transportation} />
        </div>
      </form>
    )
  }
}

export default CandidateFilters
