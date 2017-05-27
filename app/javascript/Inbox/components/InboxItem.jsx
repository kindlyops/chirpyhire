import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const InboxItem = props => (
  <div className="InboxItem">
    <div className='handle-and-timestamp'>
      <div className='handle'>
        {props.conversation.handle}
      </div>
      <div className='timestamp-container'>
        <div className='timestamp'>
          {props.conversation.timestamp}
        </div>
      </div>
    </div>
    <div className='summary'>
      {props.conversation.summary}
    </div>
  </div>
)

export default InboxItem
