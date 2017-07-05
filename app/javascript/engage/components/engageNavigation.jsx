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
          </div>
          <div className='ch--vertical-navigation-links'>
            {this.state.campaigns.map(campaign => 
              <NavLink 
                className='ch--vertical-navigation-link' 
                key={campaign.id} 
                to={`/engage/campaigns/${campaign.id}`}>{campaign.name}</NavLink>
            )}
            <NavLink 
              className='ch--vertical-navigation-link' 
              to='/engage/campaigns/new' 
              className='ch--vertical-navigation-link'>
              <i className='fa fa-plus fa-fw mr-2'></i>
              New Campaign
            </NavLink>
          </div>
        </div>
        <div className='ch--vertical-navigation--inner'>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Recruitbots</h3>
          </div>
          <div className='ch--vertical-navigation-links'>
            {this.state.bots.map(bot => 
              <NavLink 
                className='ch--vertical-navigation-link' 
                key={bot.id} 
                to={`/engage/bots/${bot.id}`}>{bot.name}</NavLink>
            )}
            <NavLink 
              className='ch--vertical-navigation-link' 
              to='/engage/bots/new' 
              className='ch--vertical-navigation-link'>
              <i className='fa fa-plus fa-fw mr-2'></i>
              New Bot
            </NavLink>
          </div>
        </div>

        
      </div>
    )
  }
}

export default EngageNavigation
