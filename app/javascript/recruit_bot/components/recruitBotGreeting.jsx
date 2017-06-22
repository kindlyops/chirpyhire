import React from 'react'

class RecruitBotGreeting extends React.Component {
  senderNotice() {
    return this.props.current_organization.sender_notice;
  }

  organizationName() {
    return this.props.current_organization.name;
  }
  
  render() {
    return (
      <div className='card'>
        <div className='card-header'>Greeting</div>
        <div className='card-block'>
          <div className='card-text'>
            Hey there! {this.senderNotice()}{"\n"}
            Want to join the {this.organizationName()} team?{"\n"}
            Well, let's get started.{"\n"}
            Please tell us more about yourself.{"\n"}
          </div>
        </div>
      </div>
    )
  }
}

export default RecruitBotGreeting
