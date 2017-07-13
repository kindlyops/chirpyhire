import React from 'react'

import BotGreeting from './components/botGreeting'
import BotQuestion from './components/botQuestion'
import BotGoal from './components/botGoal'
import SubMain from '../presentational/subMain'

class Bot extends React.Component {
  render() {
    return (
      <SubMain>
        <div className='Bot'>
          <div className='BotHeader'>
            <h2 className='BotName mb-3'>{this.props.name}</h2>
          </div>
          <BotGreeting 
            onChange={this.props.onGreetingChange}
            {...this.props.greeting} />
            <div>
              {this.props.questions.map(question =>
                <BotQuestion
                  onChange={this.props.onQuestionChange}
                  onFollowUpChange={this.props.onFollowUpChange}
                  key={question.id}
                  {...question}
                />
              )}
            </div>
            <div>
              {this.props.goals.map(goal =>
                <BotGoal
                  key={goal.id}
                  onChange={this.props.onGoalChange}
                  {...goal} />)}
            </div>
        </div>
      </SubMain>
    )
  }
}

Bot.defaultProps = {
  goals: [],
  questions: []
}

export default Bot
