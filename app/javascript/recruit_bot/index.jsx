import React from 'react'

import RecruitBotGreeting from './components/recruitBotGreeting'
import RecruitBotQuestion from './components/recruitBotQuestion'
import RecruitBotGoal from './components/recruitBotGoal'

let questions = [
    {
      type: 'certification',
      question: "Are you certified?",
      answers: "A - Yes, CNA\nB - Yes, HHA\nC - Yes, PCA\nD - Yes, Other (MA, LPN, RN, etc.)\nE - Not yet, but I want to be!"
    },
    {
      type: 'availability',
      question: "What shifts are you interested in?",
      answers: "A - Morning (AM) shifts are great!\nB - Evening (PM) shifts are great!\nC - I'm wide open for AM or PM shifts!"
    },
    {
      type: 'live_in',
      question: "Are you interested in Live-In work?",
      answers: "A - Yes, I'd love to!\nB - No, not for now!"
    },
    {
      type: 'experience',
      question: "How many years of professional caregiving experience do you have?",
      answers: "A - 0 - 1\nB - 1 - 5\nC - 6 or more\nD - I'm new to caregiving! So excited!"
    },
    {
      type: 'transportation',
      question: "How do you plan to get to work?",
      answers: "A - I have personal transportation\nB - I use public transportation\nC - I don't have a great way to get to work",
    },
    {
      type: 'drivers_license',
      question: "Do you have a current Driver's License?",
      answers: "A - Yes, of course!\nB - No, but I want to get one!",
    },
    {
      type: 'zipcode',
      question: "What is your five-digit zipcode?",
      answers: ""
    },
    {
      type: 'cpr_first_aid',
      question: "Is your CPR / First Aid certification up to date?",
      answers: "A - Yes, of course!\nB - No, but I want it to be!"
    },
    {
      type: 'skin_test',
      question: "Is your TB skin test or X-ray up to date?",
      answers: "A - Yes, of course!\nB - No, but I want it to be!"
    },
  ];

class RecruitBot extends React.Component {
  render() {
    return (
      <div className='RecruitBot--wrapper'>
        <div className='RecruitBot'>
          <RecruitBotGreeting current_organization={this.props.current_organization} />
          {questions.map(question => <RecruitBotQuestion key={question.type} current_organization={this.props.current_organization} {...question}/>)}
          <RecruitBotGoal />
        </div>
      </div>
    )
  }
}

export default RecruitBot
