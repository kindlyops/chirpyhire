import React from 'react'

import CandidateFilter from './candidateFilter'
import TextCandidateFilter from './textCandidateFilter'
import NumberCandidateFilter from './numberCandidateFilter'
import CandidateFiltersActions from './candidateFiltersActions'
import LocationCandidateFilter from './locationCandidateFilter'
import configuration from '../configuration/segments'
import update from 'immutability-helper'

class CandidateFilters extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      location: configuration.location,
      tags: {
        attribute: 'Tag',
        checked: false,
        icon: 'fa-tag',
        options: [],
        name: 'tags',
        filter: 'matches_all_tags'
      },
      name: {
        attribute: 'Name',
        checked: false,
        icon: 'fa-users'
      },
      messages: {
        attribute: 'Messages',
        checked: false,
        icon: 'fa-comments-o'
      },
      contact_stage: {
        attribute: 'Stage',
        name: 'contact_stage',
        checked: false,
        icon: 'fa-cube',
        options: [],
        filter: 'contact_stage_id_in'
      },
      campaigns: {
        attribute: 'Campaigns',
        name: 'campaigns',
        checked: false,
        icon: 'fa-paper-plane-o',
        options: [],
        filter: 'matches_all_manual_messages'
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
    const newState = R.mergeAll([{}, this.state, {
      [filter]: newFilter
    }]);

    this.props.handleSelectChange({ filter: filter, value: null });
    this.setState(newState);
  }

  componentDidMount() {
    $.get('/tags').then(tags => {
      let newState = update(this.state, { tags: { options: { $set: tags }}});
      this.setState(newState);
    });

    $.get('/contact_stages').then(stages => {
      let newState = update(this.state, { contact_stage: { options: { $set: stages }}});
      this.setState(newState);
    });

    $.get('/engage/manual/campaigns').then(campaigns => {
      let newState = update(this.state, { campaigns: { options: { $set: campaigns }}});
      this.setState(newState);
    });
  }

  render() {
    return (
      <div className='CandidateFilters ch--vertical-navigation'>
        <form className='ch--vertical-navigation--inner'>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Candidate Attributes</h3>
          </div>
          <TextCandidateFilter
            handleTextChange={this.props.handleTextChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.name} />
          <LocationCandidateFilter 
            handleLocationChange={this.props.handleLocationChange}
            toggleLocation={this.toggleLocation}
            form={this.props.form}
            {...this.state.location} />
          <CandidateFilter 
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.tags} />
          <CandidateFilter
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.contact_stage} />
          <NumberCandidateFilter
            handleNumberChange={this.props.handleNumberChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.messages} />
          <CandidateFilter
            handleSelectChange={this.props.handleSelectChange}
            toggle={this.toggle}
            form={this.props.form}
            {...this.state.campaigns} />
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
