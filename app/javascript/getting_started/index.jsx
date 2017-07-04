import React from 'react'

import RecruitBot from '../recruit_bot'
import RestartNotificationBar from '../restart_notification_bar'

class GettingStarted extends React.Component {
  constructor(props) { 
    super(props);

    this.state = {
      bots: [{
        greeting: {
          body: ''
        },
        goals: [{body: ''}],
        questions: []
      }]
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
        <RecruitBot {...this.state.bots[0]} />
      </div>
    )
  }
}

export default GettingStarted
