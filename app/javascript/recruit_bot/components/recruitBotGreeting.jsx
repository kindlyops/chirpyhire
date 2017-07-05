import React from 'react'

class RecruitBotGreeting extends React.Component {
  render() {
    return (
      <div className='card'>
        <div className='card-header'>Greeting</div>
        <div className='card-block'>
          <div className='card-text'>
            {this.props.greeting.body}
          </div>
        </div>
      </div>
    )
  }
}

export default RecruitBotGreeting
