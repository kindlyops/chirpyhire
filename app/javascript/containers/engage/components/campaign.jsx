import React from 'react'
import Select from 'react-select'
import SubMain from '../../../components/subMain'

class Campaign extends React.Component {

  render() {
    return (
      <SubMain>
        <div className='Campaign'>
          <div className='CampaignHeader'>
            <h2 className='CampaignName mb-3'>{this.props.name}</h2>
          </div>
          <div className='card CampaignSettings'>
            <div className='card-block'>
              <h5 className='card-title'>Campaign Settings</h5>
              <h6 className='card-subtitle mb-3'>Recruitbot</h6>
              <Select
                labelKey='name'
                valueKey='id'
                name="bot_campaign[bot_id]"
                value={this.props.bot_campaign.bot_id}
                options={this.props.bots}
                disabled={true}
              />
            </div>
            <div className='card-block'>
              <h6 className='card-subtitle mb-3'>Inbox</h6>
              <Select
                labelKey='name'
                valueKey='id'
                name="bot_campaign[inbox_id]"
                value={this.props.bot_campaign.inbox_id}
                options={this.props.inboxes}
                disabled={true}
              />
            </div>
          </div>
        </div>
      </SubMain>
    )
  }
}

Campaign.defaultProps = {
  bot_campaign: {},
  inboxes: [],
  bots: [],
  name: 'Untitled'
}

export default Campaign
