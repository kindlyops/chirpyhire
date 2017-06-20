import React from 'react'

import RecruitBotGreeting from './components/recruitBotGreeting'
import RecruitBotQuestion from './components/recruitBotQuestion'
import RecruitBotGoal from './components/recruitBotGoal'

class RecruitBot extends React.Component {
  render() {
    return (
      <div className='RecruitBot'>
        <RecruitBotGreeting />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotQuestion />
        <RecruitBotGoal />
      </div>
    )
  }
}

export default RecruitBot
