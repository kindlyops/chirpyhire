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
            predicates={this.predicates('name')}
            {...this.props}
           />
          <CandidateFilter
            name="Zipcode"
            icon="fa-map-marker"
            predicates={this.predicates('zipcode.zipcode')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-map-marker"
            name="City"
            predicates={this.predicates('zipcode.default_city')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-map-marker"
            name="County"
            predicates={this.predicates('zipcode.county_name')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-map-marker"
            name="State"
            predicates={this.predicates('zipcode.state_abbreviation')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-tag"
            name="Tag"
            options={this.state.tag.options}
            predicates={this.predicates('taggings.tag_id')}
            {...this.props}
           />
           <CandidateFilter
             icon="fa-cube"
             name="Stage"
             options={this.state.contact_stage.options}
             predicates={this.predicates('contact_stage_id')}
            {...this.props}
            />
          <CandidateFilter
            icon="fa-comments-o"
            name="Message"
            predicates={this.predicates('messages_count')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-paper-plane-o"
            name="Campaign"
            options={this.state.campaign.options}
            predicates={this.predicates('manual_message_participants.manual_message_id')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-calendar"
            name="First Seen"
            predicates={this.predicates('created_at')}
            {...this.props}
           />
          <CandidateFilter
            icon="fa-calendar"
            name="Last Seen"
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
