import React from 'react'
import ConversationHeader from './conversationHeader'
import ConversationBody from './conversationBody'

class ConversationChat extends React.Component {
  render() {
    return (<div className='ConversationChat'>
      <ConversationHeader 
        contact={this.props.contact}
      />
      <ConversationBody 
        contact={this.props.contact}
        messages={this.props.messages}
      />
    </div>);
  }
}

export default ConversationChat
