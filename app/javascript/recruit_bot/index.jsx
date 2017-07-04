import React from 'react'

import RecruitBotGreeting from './components/recruitBotGreeting'
import RecruitBotQuestion from './components/recruitBotQuestion'
import RecruitBotGoal from './components/recruitBotGoal'

class RecruitBot extends React.Component {
  constructor(props) { 
    super(props);

    this.state = {
      subscription: {},
      bot: {
        greeting: {
          body: ''
        },
        goals: [{body: ''}],
        questions: []
      }
    }
  }

  botUrl() {
    return `/bots/${this.props.id}`;
  }

  componentDidMount() {
    $.get(this.botUrl()).then(bot => {
      this.setState({ bot: bot });
    });
    this.connect(this.props.id);
  }

  render() {
    return (
      <div className='RecruitBot--wrapper'>
        <div className='RecruitBot'>
          <RecruitBotGreeting greeting={this.state.bot.greeting} />
          {this.state.bot.questions.map(question => <RecruitBotQuestion key={question.id} {...question}/>)}
          <RecruitBotGoal goal={this.state.bot.goals[0]} />
        </div>
      </div>
    )
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

export default RecruitBot
