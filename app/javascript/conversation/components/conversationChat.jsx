import React from 'react'
import ConversationHeader from './conversationHeader'
import ConversationBody from './conversationBody'

class ConversationChat extends React.Component {
  render() {
    return (<div className='ConversationChat'>
      <ConversationHeader
        handleFilterChange={this.props.handleFilterChange}
        conversation={this.props.conversation}
        contact={this.props.contact}
      />
      <ConversationBody
        conversation={this.props.conversation}
        contact={this.props.contact}
        parts={this.props.parts}
      />
    </div>);
  }
}

export default ConversationChat
