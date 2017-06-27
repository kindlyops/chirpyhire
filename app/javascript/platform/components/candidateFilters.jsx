import React from 'react'

import CandidateFilter from './candidateFilter'
import CandidateFiltersActions from './candidateFiltersActions'
import LocationCandidateFilter from './locationCandidateFilter'
import configuration from '../configuration/segments'
import update from 'immutability-helper'

class CandidateFilters extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      location: configuration.location,
      tag: {
        attribute: 'Tag',
        checked: false,
        icon: 'fa-tag',
        options: []
      }
    }

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

  componentDidMount() {
    $.get('/tags').then(tags => {
      let newState = update(this.state, { tag: { options: { $set: tags }}});
      this.setState(newState);
    })
  }

  render() {
    return (
      <div className='CandidateFilters ch--vertical-navigation'>
        <form className='ch--vertical-navigation--inner'>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Candidate Attributes</h3>
          </div>
          <LocationCandidateFilter 
            handleLocationChange={this.props.handleLocationChange}
            toggleLocation={this.toggleLocation}
            form={this.props.form}
            {...this.state.location} />
          <CandidateFilter 
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.tag} />
        </form>
        <CandidateFiltersActions 
          handleSegment={this.props.handleSegment} 
          form={this.props.form} 
        />
      </div>
    )
  }
}

export default CandidateFilters
