import React from 'react'

import RecruitBotGreeting from './components/recruitBotGreeting'
import RecruitBotQuestion from './components/recruitBotQuestion'
import RecruitBotGoal from './components/recruitBotGoal'

class RecruitBot extends React.Component {
  render() {
    return (
      <div className='RecruitBot--wrapper'>
        <div className='RecruitBot'>
          <RecruitBotGreeting greeting={this.props.greeting} />
          {this.props.questions.map(question => <RecruitBotQuestion key={question.id} {...question}/>)}
          <RecruitBotGoal goal={this.props.goals[0]} />
        </div>
      </div>
    )
  }
}

RecruitBot.defaultProps = {
  greeting: {
    body: ''
  },
  goals: [{body: ''}],
  questions: []
}

export default RecruitBot
