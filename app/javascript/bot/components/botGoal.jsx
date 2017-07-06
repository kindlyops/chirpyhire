import React from 'react'

class BotGoal extends React.Component {
  render() {
    return (
      <div className='card'>
        <div className='card-header goal--header'>
          <span className='bot-card--label'>Goal:</span>
          <span className='bot-card--title'>Caregiver Pre-screened!</span>
        </div>
        <div className='card-block'>
          <div className='card-text'>
            {this.props.goal.body}
          </div>
        </div>
      </div>
    )
  }
}

export default BotGoal
