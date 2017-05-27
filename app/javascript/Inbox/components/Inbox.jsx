import React from 'react'
import InboxItem from './inboxItem'

const Inbox = props => (
  <div className="Inbox">
    <div>
      {props.conversations.map((conversation) =>
       <InboxItem key={conversation.id} {...conversation} />
      )}
    </div>
  </div>
)

export default Inbox
