import React from 'react'

import RestartNotificationBar from '../restart_notification_bar'
import EngageNavigation from './components/engageNavigation'
import CampaignContainer from './components/campaignContainer'
import BotContainer from './components/botContainer'

import { Route } from 'react-router-dom'
import Page from '../presentational/page'
import Header from '../presentational/header'
import Main from '../presentational/main'

class Engage extends React.Component {
  constructor(props) { 
    super(props);

    this.state = {}
  }

  botsUrl() {
    return `/bots`;
  }

  campaignsUrl() {
    return `/campaigns`;
  }

  inboxesUrl() {
    return `/inboxes`;
  }

  componentDidMount() {
    $.get(this.botsUrl()).then(bots => {
      this.setState({ bots: bots });
    });

    $.get(this.campaignsUrl()).then(campaigns => {
      this.setState({ campaigns: campaigns });
    });

    $.get(this.inboxesUrl()).then(inboxes => {
      this.setState({ inboxes: inboxes });
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
          <EngageNavigation {...this.state} />
          <Route path={this.props.match.url + '/bots/:id'} render={props => <BotContainer {...this.state} {...props} />} />
          <Route path={this.props.match.url + '/campaigns/:id'} render={props => <CampaignContainer {...this.state} {...props} />} />
        </Main>
      </Page>
    )
  }
}

export default Engage
