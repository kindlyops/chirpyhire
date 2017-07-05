import React from 'react'

import RestartNotificationBar from '../restart_notification_bar'
import EngageNavigation from './components/engageNavigation'
import CampaignContainer from './components/campaignContainer'
import NewCampaignContainer from './components/newCampaignContainer'
import BotContainer from './components/botContainer'
import NewBotContainer from './components/newBotContainer'

import { Route, Switch } from 'react-router-dom'
import Page from '../presentational/page'
import Header from '../presentational/header'
import Main from '../presentational/main'

class Engage extends React.Component {
  render() {
    return (
      <Page>
        <RestartNotificationBar {...this.props} />
        <Header>
          <h1>Engage</h1>
        </Header>
        <Main>
          <EngageNavigation />
          <Switch>
            <Route path={this.props.match.url + '/campaigns/new'} component={NewCampaignContainer} />
            <Route path={this.props.match.url + '/campaigns/:campaignId'} component={CampaignContainer} />
            <Route path={this.props.match.url + '/bots/new'} component={NewBotContainer} />
            <Route path={this.props.match.url + '/bots/:campaignId'} component={BotContainer} />
          </Switch>
        </Main>
      </Page>
    )
  }
}

export default Engage
