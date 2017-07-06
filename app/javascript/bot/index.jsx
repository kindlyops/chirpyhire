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
            <h2 className='BotName'>{this.props.name}</h2>
          </div>
          <BotGreeting 
            onChange={this.props.onGreetingChange}
            {...this.props.greeting} />
          {this.props.questions.map(question => 
            <BotQuestion 
              onChange={this.props.onQuestionChange}
              key={question.id} 
              {...question} 
            />
          )}
          {this.props.goals.map(goal => 
            <BotGoal 
              key={goal.id}
              onChange={this.props.onGoalChange}
              {...goal} />)}
        </div>
      </SubMain>
    )
  }
}

Bot.defaultProps = {
  greeting: {
    body: ''
  },
  goals: [{body: ''}],
  questions: []
}

export default Bot
