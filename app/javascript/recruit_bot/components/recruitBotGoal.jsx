import React from 'react'

class RecruitBotGoal extends React.Component {
  render() {
    return (
      <div className='card'>
        <div className='card-header'>Goal: Caregiver Pre-screened!</div>
        <div className='card-block'>
          <div className='card-text'>
            {this.props.goal.body}
          </div>
        </div>
      </div>
    )
  }
}

export default RecruitBotGoal
