import React from 'react'
import Toggle from 'react-toggle'

class RecruitBotQuestion extends React.Component {
  render() {
    return (
      <div className='card'>
        <div className='card-header'>
          <span className='question'>{`Question: ${this.props.question}`}</span>
          <label className='toggle'>
            <Toggle
              defaultChecked={this.props.checked}
              onChange={() => {}} />
          </label>
        </div>
        <div className='card-block'>
          <div className='card-text'>
            {`${this.props.answers}`}
          </div>
        </div>
      </div>
    )
  }
}

export default RecruitBotQuestion
