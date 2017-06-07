import React from 'react'
import ConversationHeader from './conversationHeader'
import ConversationBody from './conversationBody'

class ConversationChat extends React.Component {
  render() {
    return (<div className='ConversationChat'>
      <ConversationHeader
        inbox_conversation={this.props.inbox_conversation}
        contact={this.props.contact}
      />
      <ConversationBody
        inbox_conversation={this.props.inbox_conversation}
        contact={this.props.contact}
        messages={this.props.messages}
      />
    </div>);
  }
}

export default ConversationChat
