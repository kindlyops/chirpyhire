import React from 'react'

import RecruitBot from '../recruit_bot'
import RestartNotificationBar from '../restart_notification_bar'

class GettingStarted extends React.Component {
  render() {
    return (
      <div className='ch--Page'>
        <RestartNotificationBar {...this.props} />
        <div className='ch--Header'>
          <h1>Getting Started</h1>
        </div>
        <RecruitBot current_organization={this.props.current_organization} />
      </div>
    )
  }
}

export default GettingStarted
