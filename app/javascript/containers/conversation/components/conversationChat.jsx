import React from 'react'
import ConversationHeader from './conversationHeader'
import ConversationBody from './conversationBody'

class ConversationChat extends React.Component {
  render() {
    return (<div className='ConversationChat'>
      <ConversationHeader
        conversation={this.props.conversation}
        contact={this.props.contact}
      />
      <ConversationBody
        conversation={this.props.conversation}
        contact={this.props.contact}
        messages={this.props.messages}
      />
    </div>);
  }
}

export default ConversationChat
