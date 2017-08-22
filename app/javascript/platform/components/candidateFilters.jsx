import React from 'react'

import CandidateFilter from './candidateFilter'
import TextCandidateFilter from './textCandidateFilter'
import NumberCandidateFilter from './numberCandidateFilter'
import CandidateFiltersActions from './candidateFiltersActions'
import LocationCandidateFilter from './locationCandidateFilter'
import DateCandidateFilter from './dateCandidateFilter'

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
      },
      created_at: {
        attribute: 'First Seen',
        name: 'created_at',
        checked: false,
        icon: 'fa-calendar'
      },
      last_reply_at: {
        attribute: 'Last Seen',
        name: 'last_reply_at',
        checked: false,
        icon: 'fa-calendar'
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
          <PredicateBuilder
            type="string"
            attribute="name"
            comparison="contains"
            value={this.predicateValue('name')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="string"
            attribute="zipcode.zipcode"
            comparison="eq"
            value={this.predicateValue('zipcode.zipcode')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="string"
            attribute="zipcode.default_city"
            comparison="eq"
            value={this.predicateValue('zipcode.default_city')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="string"
            attribute="zipcode.county_name"
            comparison="eq"
            value={this.predicateValue('zipcode.county_name')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="string"
            attribute="zipcode.state_abbreviation"
            comparison="eq"
            value={this.predicateValue('zipcode.state_abbreviation')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="tag"
            attribute="taggings.tag_id"
            comparison="eq"
            value={this.predicateValue('taggings.tag_id')}
            onChange={this.props.onChange}
           />
           <PredicateBuilder
             type="integer"
             attribute="contact_stage_id"
             comparison="eq"
             value={this.predicateValue('contact_stage_id')}
             onChange={this.props.onChange}
            />
          <PredicateBuilder
            type="integer"
            attribute="messages_count"
            comparison="eq"
            value={this.predicateValue('messages_count')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="manual_message"
            attribute="manual_message_participants.manual_message_id"
            comparison="eq"
            value={this.predicateValue('manual_message_participants.manual_message_id')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="date"
            attribute="created_at"
            comparison="eq"
            value={this.predicateValue('created_at')}
            onChange={this.props.onChange}
           />
          <PredicateBuilder
            type="date"
            attribute="last_reply_at"
            comparison="eq"
            value={this.predicateValue('last_reply_at')}
            onChange={this.props.onChange}
           />
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
