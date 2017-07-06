import React from 'react'

import { NavLink } from 'react-router-dom'

class EngageNavigation extends React.Component {
  render() {
    return (
      <div className='EngageNavigation ch--vertical-navigation'>
        <div className='ch--vertical-navigation--inner'>
          <div className='ch--vertical-navigation-header'>
            <h3 className='small-uppercase'>Recruitbots</h3>
          </div>
          <div className='ch--vertical-navigation-links'>
            {this.props.bots.map(bot => 
              <NavLink 
                className='ch--vertical-navigation-link' 
                key={bot.id} 
                to={`/engage/bots/${bot.id}`}>{bot.name}</NavLink>
            )}
          </div>
        </div>

        
      </div>
    )
  }
}

export default EngageNavigation
