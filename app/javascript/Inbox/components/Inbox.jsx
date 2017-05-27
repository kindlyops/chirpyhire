import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import InboxItem from './inboxItem'

const Inbox = props => (
  <div className="Inbox">
    <div>
      {props.conversations.map((conversation) =>
       <InboxItem key={conversation.id} conversation={conversation} />
      )}
    </div>
  </div>
)

export default Inbox
