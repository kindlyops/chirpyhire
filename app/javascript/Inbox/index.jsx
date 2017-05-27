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

  componentDidMount() {
    var channel = { channel: 'InboxChannel' };
    var that = this;
    App.inbox = App.cable.subscriptions.create(channel, {
      received: function({ conversation, conversations_count }) {
        let conversations = this.state.conversations;
        let index = R.findIndex(R.propEq('id', conversation.id), conversations);
        if(index) {
          conversations[index] = conversation
        } else {
          conversations.push(conversation)
        }

        that.setState({
          conversations_count: conversations_count,
          conversations: conversations
        })
      }
    });
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
