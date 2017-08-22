import React from 'react'

import CandidateFilter from './candidateFilter'
import CandidateFiltersActions from './candidateFiltersActions'
import update from 'immutability-helper'

class CandidateFilters extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      tag: {
        options: []
      },
      contact_stage: {
        options: []
      },
      campaign: {
        options: []
      }
    }
  }

  componentDidMount() {
    $.get('/tags').then(tags => {
      let newState = update(this.state, { tag: { options: { $set: tags }}});
      this.setState(newState);
    });

    $.get('/contact_stages').then(stages => {
      let newState = update(this.state, { contact_stage: { options: { $set: stages }}});
      this.setState(newState);
    });

    $.get('/engage/manual/campaigns').then(campaigns => {
      let newState = update(this.state, { campaign: { options: { $set: campaigns }}});
      this.setState(newState);
    });
  }

  predicates(attribute) {
    return _.filter(this.props.form.predicates, { attribute: attribute });
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
            attribute="name"
            type="string"
            predicates={this.predicates('name')}
            {...this.props}
           />
          <CandidateFilter
            name="Zipcode"
            icon="fa-map-marker"
            attribute="zipcode_zipcode"
            type="string"
            predicates={this.predicates('zipcode_zipcode')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-map-marker"
            attribute="zipcode_default_city"
            type="string"
            name="City"
            predicates={this.predicates('zipcode_default_city')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-map-marker"
            attribute="zipcode_county_name"
            type="string"
            name="County"
            predicates={this.predicates('zipcode_county_name')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-map-marker"
            attribute="zipcode_state_abbreviation"
            type="string"
            name="State"
            predicates={this.predicates('zipcode_state_abbreviation')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-tag"
            attribute="taggings_tag_id"
            name="Tag"
            type="select"
            options={this.state.tag.options}
            predicates={this.predicates('taggings_tag_id')}
            {...this.props}
           />
           <CandidateFilter
             icon="fa-cube"
             attribute="contact_stage_id"
             type="select"
             name="Stage"
             options={this.state.contact_stage.options}
             predicates={this.predicates('contact_stage_id')}
            {...this.props}
            />
          <CandidateFilter
            icon="fa-comments-o"
            attribute="messages_count"
            type="integer"
            name="Message"
            predicates={this.predicates('messages_count')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-paper-plane-o"
            attribute="manual_message_participants_manual_message_id"
            name="Campaign"
            type="select"
            options={this.state.campaign.options}
            predicates={this.predicates('manual_message_participants_manual_message_id')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-calendar"
            attribute="created_at"
            name="First Seen"
            type="date"
            predicates={this.predicates('created_at')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-calendar"
            attribute="last_reply_at"
            name="Last Seen"
            type="date"
            predicates={this.predicates('last_reply_at')}
            {...this.props}
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
