import React from 'react'

import RecruitBot from '../recruit_bot'
import RestartNotificationBar from '../restart_notification_bar'
import Page from '../presentational/page'
import Header from '../presentational/header'

class Bots extends React.Component {
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
      <Page>
        <RestartNotificationBar {...this.props} />
        <Header>
          <h1>Bots</h1>
        </Header>
        {this.state.bots.map(bot => <RecruitBot key={bot.id} id={bot.id} />)}
      </Page>
    )
  }
}

export default Bots
