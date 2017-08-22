import React from 'react'

import CandidateFilter from './candidateFilter'
import CandidateFiltersActions from './candidateFiltersActions'
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

  predicates(attribute) {
    let mock = [{type: "date", attribute: "last_reply_at", comparison: "lt", value: "30"},
                {type: "date", attribute: "last_reply_at", comparison: "gt", value: "60"},
                {type: "integer", attribute: "messages_count", comparison: "gt", value: "5"}]

    return _.filter(mock, { attribute: attribute });
  }

  render() {
    return (
      <div className='CandidateFilters ch--vertical-navigation'>
        <form className='ch--vertical-navigation--inner'>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Candidate Attributes</h3>
          </div>
          <CandidateFilter
            name="Name"
            icon="fa-users"
            predicates={this.predicates('name')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            name="Zipcode"
            icon="fa-map-marker"
            predicates={this.predicates('zipcode.zipcode')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-map-marker"
            name="City"
            predicates={this.predicates('zipcode.default_city')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-map-marker"
            name="County"
            predicates={this.predicates('zipcode.county_name')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-map-marker"
            name="State"
            predicates={this.predicates('zipcode.state_abbreviation')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-tag"
            name="Tag"
            predicates={this.predicates('taggings.tag_id')}
            onChange={this.props.onChange}
           />
           <CandidateFilter
             icon="fa-cube"
             name="Stage"
             predicates={this.predicates('contact_stage_id')}
             onChange={this.props.onChange}
            />
          <CandidateFilter
            icon="fa-comments-o"
            name="Message"
            predicates={this.predicates('messages_count')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-paper-plane-o"
            name="Campaign"
            predicates={this.predicates('manual_message_participants.manual_message_id')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-calendar"
            name="First Seen"
            predicates={this.predicates('created_at')}
            onChange={this.props.onChange}
           />
          <CandidateFilter
            icon="fa-calendar"
            name="Last Seen"
            predicates={this.predicates('last_reply_at')}
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
