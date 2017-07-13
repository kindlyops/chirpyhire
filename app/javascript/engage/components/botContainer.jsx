import React from 'react'

import Bot from '../../bot'
import update from 'immutability-helper'

class BotContainer extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      subscription: {},
      bot: {}
    }
    this.onGreetingChange = this.onGreetingChange.bind(this);
    this.onQuestionChange = this.onQuestionChange.bind(this);
    this.onGoalChange = this.onGoalChange.bind(this);
    this.onFollowUpChange = this.onFollowUpChange.bind(this);
  }

  onFollowUpChange(event) {
    let id = parseInt(event.target.id);
    let qId = parseInt(event.target.dataset.questionId);
    let qIndex = R.findIndex(R.propEq('id', qId), this.state.bot.questions);
    let follow_ups = this.state.bot.questions[qIndex].follow_ups;
    let index = R.findIndex(R.propEq('id', id), follow_ups);

    this.setState(update(this.state, {
      bot: {
        questions: {
          [qIndex]: {
            follow_ups: {
              [index]: {
                body: {
                  $set: event.target.value
                }
              }
            }
          }
        }
      }
    }));
  }

  onGreetingChange(event) {
    this.setState(update(this.state, {
      bot: {
        greeting: {
          body: {
            $set: event.target.value
          }
        }
      }
    }));
  }

  onQuestionChange(event) {
    let id = parseInt(event.target.id);
    let index = R.findIndex(R.propEq('id', id), this.state.bot.questions);

    this.setState(update(this.state, {
      bot: {
        questions: {
          [index]: {
            body: {
              $set: event.target.value
            }
          }
        }
      }
    }));
  }

  onGoalChange(event) {
    let id = parseInt(event.target.id);
    let index = R.findIndex(R.propEq('id', id), this.state.bot.goals);

    this.setState(update(this.state, {
      bot: {
        goals: {
          [index]: {
            body: {
              $set: event.target.value
            }
          }
        }
      }
    }));
  }

  render() {
    return(
      <Bot 
        onQuestionChange={this.onQuestionChange}
        onGreetingChange={this.onGreetingChange}
        onGoalChange={this.onGoalChange}
        onFollowUpChange={this.onFollowUpChange}
        {...this.state.bot}>
      </Bot>
    )
  }

  botId() {
    return this.props.match.params.id;
  }

  botUrl(botId) {
    return `/bots/${botId}`;
  }

  componentWillReceiveProps(nextProps) {
    let nextBotId = nextProps.match.params.id;
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
