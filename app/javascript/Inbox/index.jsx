import React from 'react'
import ReactDOM from 'react-dom'
import Inbox from './components/inbox'
import InboxDropdown from './components/inboxDropdown'

class InboxWrapper extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      conversations_count: props.conversations_count,
      conversations: props.conversations 
    };
    this.handleConversationsChange = this.handleConversationsChange.bind(this);
  }

  render() {
    return <div className="InboxWrapper">
              <InboxDropdown conversations_count={this.state.conversations_count} />
              <Inbox
                conversations_count={this.state.conversations_count}
                conversations={this.state.conversations}
                onConversationsChange={this.handleConversationsChange}
               />
            </div>;
  }

  handleConversationsChange(conversations) {
    this.setState({ conversations: conversations });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('inbox')
  const data = JSON.parse(node.getAttribute('data'))

  ReactDOM.render(<InboxWrapper {...data} />, node)
})
