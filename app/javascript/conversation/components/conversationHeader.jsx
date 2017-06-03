import React from 'react'

const ConversationHeader = props => (
  <header className='chat-header'>
    <div className='channel-header'>
      <div className='messages-header'>
        <div className='channel-title'>
          <div className='channel-name-container'>
            <div className='channel-name'>
              <span>{props.contact.handle}</span>
            </div>
          </div>
          <div className='channel-header-info'>
            <div className='channel-header-info-item'>
              {props.contact.phone_number}
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>
)

export default ConversationHeader
