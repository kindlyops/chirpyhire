import React from 'react'

import RestartNotificationBar from '../restart_notification_bar'
import EngageNavigation from './components/engageNavigation'
import CampaignContainer from './components/campaignContainer'
import NewCampaignContainer from './components/newCampaignContainer'
import BotContainer from './components/botContainer'
import NewBotContainer from './components/newBotContainer'

import { Route } from 'react-router-dom'
import Page from '../presentational/page'
import Header from '../presentational/header'
import Main from '../presentational/main'

class Engage extends React.Component {
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
          <h1>Engage</h1>
        </Header>
        <Main>
          <EngageNavigation bots={this.state.bots} />
          <Route path={this.props.match.url + '/bots/:botId'} component={BotContainer} />
          <Route path={this.props.match.url + '/campaigns/:campaignId'} component={CampaignContainer} />
        </Main>
      </Page>
    )
  }
}

export default Engage
