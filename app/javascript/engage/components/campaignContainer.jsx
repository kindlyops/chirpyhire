import React from 'react'

import Campaign from './campaign'

class CampaignContainer extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      subscription: {},
      campaign: {}
    }
  }

  render() {
    return(<Campaign {...this.props} {...this.state.campaign}></Campaign>)
  }

  campaignId() {
    return this.props.match.params.id;
  }

  campaignUrl(campaignId) {
    return `/campaigns/${campaignId}`;
  }

  componentWillReceiveProps(nextProps) {
    let nextCampaignId = nextProps.match.params.id;
    let campaignId = this.campaignId();

    if(nextCampaignId !== campaignId) {
      this.load(nextCampaignId);
      this.reconnect(nextCampaignId);
    }
  }

  componentDidMount() {
    this.load(this.campaignId());
    this.connect(this.campaignId());
  }

  componentWillUnmount() {
    this.disconnect();
  }

  load(campaignId) {
    $.get(this.campaignUrl(campaignId)).then(campaign => {
      this.setState({ campaign: campaign });
    });
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.subscription);
  }

  reconnect(campaignId) {
    this.disconnect();
    this.connect(campaignId);
  }

  connect(campaignId) {
    let channel = { channel: 'CampaignsChannel', id: campaignId };
    let subscription = App.cable.subscriptions.create(
      channel, this._channelConfig()
    );

    this.setState({ subscription: subscription });
  }

  _channelConfig() {
    return {
      received: this._received.bind(this)
    }
  }

  _received(receivedCampaign) {
    this.setState({ campaign: receivedCampaign });
  }
}

export default CampaignContainer
