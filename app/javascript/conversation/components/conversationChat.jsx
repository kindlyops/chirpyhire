import React from 'react'
import ConversationHeader from './conversationHeader'
import ConversationBody from './conversationBody'

class ConversationChat extends React.Component {
  render() {
    return (<div className='ConversationChat'>
      <ConversationHeader 
        contact={this.props.conversation.contact}
      />
      <ConversationBody 
        contact={this.props.conversation.contact}
        messages={this.props.conversation.messages}
      />
    </div>);
  }
}

export default ConversationChat
