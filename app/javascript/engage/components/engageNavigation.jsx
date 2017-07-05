import React from 'react'

import { NavLink } from 'react-router-dom'

class EngageNavigation extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      campaigns: [{id: 1, name: 'Test Campaign'}],
      bots: [{id: 1, name: 'Chirpy'}]
    }
  }
  render() {
    return (
      <div className='EngageNavigation ch--vertical-navigation'>
        <div className='ch--vertical-navigation--inner'>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Campaigns</h3>
            {this.state.campaigns.map(campaign => 
              <NavLink key={campaign.id} to={`/engage/campaigns/${campaign.id}`}>{campaign.name}</NavLink>
            )}
          </div>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Recruitbots</h3>
            {this.state.bots.map(bot => 
              <NavLink key={bot.id} to={`/engage/bots/${bot.id}`}>{bot.name}</NavLink>
            )}
          </div>
        </div>

        
      </div>
    )
  }
}

export default EngageNavigation
