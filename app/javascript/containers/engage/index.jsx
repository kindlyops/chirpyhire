import React from 'react'

import RestartNotificationBar from '../restart_notification_bar'
import EngageNavigation from './components/engageNavigation'
import CampaignContainer from './components/campaignContainer'
import BotContainer from './components/botContainer'

import { Route } from 'react-router-dom'
import Page from '../../components/page'
import Header from '../../components/header'
import Main from '../../components/main'

import { getBots, getCampaigns, getInboxes } from '../../actions'
import { connect } from 'react-redux'

const getData = ({ getBots, getCampaigns, getInboxes }) => {
  getBots();
  getCampaigns();
  getInboxes();
}

class Engage extends React.Component {
  componentWillMount() {
    getData(this.props);
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

const mapStateToProps = (state, ownProps) => {
  const {
    entities: { bots, campaigns, inboxes }
  } = state

  return { bots, campaigns, inboxes }
}

export default connect(mapStateToProps, {
  getBots,
  getCampaigns,
  getInboxes
})(Engage)
