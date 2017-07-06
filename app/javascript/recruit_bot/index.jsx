import React from 'react'

import RecruitBotGreeting from './components/recruitBotGreeting'
import RecruitBotQuestion from './components/recruitBotQuestion'
import RecruitBotGoal from './components/recruitBotGoal'
import SubMain from '../presentational/subMain'

class RecruitBot extends React.Component {
  render() {
    return (
      <SubMain>
        <div className='RecruitBot'>
          <RecruitBotGreeting greeting={this.props.greeting} />
          {this.props.questions.map(question => <RecruitBotQuestion key={question.id} {...question}/>)}
          <RecruitBotGoal goal={this.props.goals[0]} />
        </div>
      </SubMain>
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
