import React from 'react'

import RecruitBot from '../../recruit_bot'

class BotContainer extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      subscription: {},
      bot: {}
    }
  }

  render() {
    return(<RecruitBot {...this.state.bot}></RecruitBot>)
  }

  botId() {
    return this.props.match.params.botId;
  }

  botUrl(botId) {
    return `/bots/${botId}`;
  }

  componentWillReceiveProps(nextProps) {
    let nextBotId = nextProps.match.params.botId;
    let botId = this.botId();

    if(nextBotId !== botId) {
      this.load(nextBotId);
      this.reconnect(nextBotId);
    }
  }

  componentDidMount() {
    this.load(this.botId());
    this.connect(this.botId());
  }

  componentWillUnmount() {
    this.disconnect();
  }

  load(botId) {
    $.get(this.botUrl(botId)).then(bot => {
      this.setState({ bot: bot });
    });
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.subscription);
  }

  reconnect(botId) {
    this.disconnect();
    this.connect(botId);
  }

  connect(botId) {
    let channel = { channel: 'BotsChannel', id: botId };
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

  _received(receivedBot) {
    this.setState({ bot: receivedBot });
  }
}

export default BotContainer
