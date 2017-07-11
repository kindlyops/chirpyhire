import React from 'react'

import Bot from '../../bot'
import { getBot, updateBot } from '../../../actions'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

const getData = ({ getBot, match: { params } }) => {
  getBot(params.id);
}

class BotContainer extends React.Component {
  constructor(props) {
    super(props);

    this.state = { subscription: {} }
    this.onSubmit = this.onSubmit.bind(this);
  }

  onSubmit(values) {
    console.log(values);
  }

  render() {
    return(
      <Bot 
        onSubmit={this.onSubmit}
        {...this.props.bot}>
      </Bot>
    )
  }

  botId() {
    return this.props.match.params.id;
  }

  componentDidUpdate({ match: { params }}) {
    let botId = this.botId();
    if(params.id !== botId) {
      this.reconnect(botId);
    }
  }

  componentDidMount() {
    getData(this.props);
    this.connect(this.botId());
  }

  componentWillUnmount() {
    this.disconnect();
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
      received: this.props.updateBot.bind(this)
    }
  }
}

const mapStateToProps = (state, { match: { params } }) => {
  const {
    entities: { bots }
  } = state

  const bot = bots.byId[params.id]
  return { bot }
}

export default withRouter(connect(mapStateToProps, {
  getBot,
  updateBot
})(BotContainer))
