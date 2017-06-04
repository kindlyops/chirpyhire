import React from 'react'
import update from 'immutability-helper'
import moment from 'moment'

import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'
import Conversation from 'conversation'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      subscription: {},
      inbox_conversations: [],
      inbox: {},
      filter: 'All'
    };

    this.handleFilterChange = this.handleFilterChange.bind(this);
  }

  inboxId() {
    return this.props.match.params.inboxId;
  }

  id() {
    return this.props.match.params.id;
  }

  conversation() {
    let inbox_conversation = this.state.inbox_conversations.find((inbox_conversation) => (
      parseInt(this.id()) === inbox_conversation.conversation_id
    ))

    if(inbox_conversation) {
      return <Conversation 
                inbox_conversation={inbox_conversation}
                inbox={this.state.inbox} />;
    } else {
      return this.emptyInbox();
    }
  }

  inboxConversationsByRecency() {
    return this.state.inbox_conversations.sort((first, second) => (
      moment(second.last_message_created_at) - moment(first.last_message_created_at)
    ))
  }

  emptyInbox() {
    return (
      <div className="empty-message d-flex flex-column align-items-center justify-content-center">
        <h4>No one to message yet...</h4>
        <blockquote className='blockquote mt-5'>
          <p className='mb-0'>Believe you can</p>
          <p className='mb-0'>and you're halfway there</p>
          <footer className='mt-3 blockquote-footer'>Theodore Roosevelt</footer>
        </blockquote>
      </div>
      )
  }

  render() {
    return <div className="Inbox">
              <div className='Conversations'>
                <ConversationsMenu 
                  filter={this.state.filter}
                  inbox_conversations={this.state.inbox_conversations}
                  handleFilterChange={this.handleFilterChange}
                />        
                <ConversationsList
                  inboxId={this.inboxId()}
                  filter={this.state.filter}
                  inbox_conversations={this.inboxConversationsByRecency()}
                 />
              </div>
              {this.conversation()}
            </div>;
  }

  inboxConversationsURL() {
    return `/inboxes/${this.inboxId()}/inbox_conversations`;
  }

  inboxURL() {
    return `/inboxes/${this.inboxId()}`;
  }

  componentDidMount() {
    this.load();
    this.connect();
  }

  componentWillUnmount() {
    this.disconnect();
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.subscription);
  }

  load() {
    $.get(this.inboxURL()).then((inbox) => {
      this.setState({ inbox: inbox });
    });
    
    $.get(this.inboxConversationsURL()).then((inbox_conversations) => {
      this.setState({ inbox_conversations: inbox_conversations });
    });
  }

  connect() {
    let channel = { channel: 'InboxConversationsChannel' };
    let subscription = App.cable.subscriptions.create(
      channel, this._channelConfig()
    );

    this.setState({ subscription: subscription });
  }

  _channelConfig() {
    return {
      received: this._received.bind(this)
    }
  }

  _received(receivedInboxConversation) {
    let index = this.state.inbox_conversations.findIndex((inbox_conversation) => (
      receivedInboxConversation.id === inbox_conversation.id
    ))

    if(Number.isInteger(index)) {
      let new_inbox_conversations = update(
        this.state.inbox_conversations,
        { $splice: [[index, 1, receivedInboxConversation]] }
      )

      this.setState({
        inbox_conversations: new_inbox_conversations
      })
    } else {
      this.setState({
        inbox_conversations: this.state.inbox_conversations.concat([receivedInboxConversation])
      })
    }
  }

  handleFilterChange(filter) {
    this.setState({ filter: filter });
  }
} 

export default Inbox
