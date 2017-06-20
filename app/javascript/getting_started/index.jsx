import React from 'react'

import RecruitBot from '../recruit_bot'

class GettingStarted extends React.Component {
  render() {
    return (
      <div className='ch--Page'>
        <div className='ch--Header'>
          <h1>Getting Started</h1>
        </div>
        <RecruitBot />
      </div>
    )
  }
}

export default GettingStarted
