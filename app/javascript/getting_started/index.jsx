import React from 'react'

import RecruitBot from '../recruit_bot'
import RestartNotificationBar from '../restart_notification_bar'

class GettingStarted extends React.Component {
  constructor(props) { 
    super(props);

    this.state = {
      bots: []
    }
  }

  botsUrl() {
    return `/bots`;
  }

  componentDidMount() {
    $.get(this.botsUrl()).then(bots => {
      this.setState({ bots: bots });
    });
  }

  render() {
    return (
      <div className='ch--Page'>
        <RestartNotificationBar {...this.props} />
        <div className='ch--Header'>
          <h1>Getting Started</h1>
        </div>
        {this.state.bots.slice(0, 1).map(bot => <RecruitBot key={bot.id} id={bot.id} />)}
      </div>
    )
  }
}

export default GettingStarted
