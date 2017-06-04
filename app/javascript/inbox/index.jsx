import React from 'react'
import update from 'immutability-helper'
import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'
import Conversation from 'conversation'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      subscription: {},
      conversations: [],
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
    let conversation = this.state.conversations.find((conversation) => (
      parseInt(this.id()) === conversation.id
    ))

    if(conversation) {
      return <Conversation 
                conversation={conversation}
                inbox={this.state.inbox} />;
    } else {
      return this.emptyInbox();
    }
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
                  conversations={this.state.conversations}
                  handleFilterChange={this.handleFilterChange}
                />        
                <ConversationsList
                  inboxId={this.inboxId()}
                  filter={this.state.filter}
                  conversations={this.state.conversations}
                 />
              </div>
              {this.conversation()}
            </div>;
  }

  conversationsURL() {
    return `/inboxes/${this.inboxId()}/conversations`;
  }

  inboxURL() {
    return `/inboxes/${this.inboxId()}`;
  }

  componentDidMount() {
    this.load();
    this.connect();
  }

  componentDidUnmount() {
    this.disconnect();
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.subscription);
  }

  load() {
    $.get(this.inboxURL()).then((inbox) => {
      this.setState({ inbox: inbox });
    });
    
    $.get(this.conversationsURL()).then((conversations) => {
      this.setState({ conversations: conversations });
    });
  }

  connect() {
    let channel = { channel: 'ConversationsChannel', id: this.id() };
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

  _received(receivedConversation) {
    let index = this.state.conversations.findIndex((conversation) => (
      receivedConversation.id === conversation.id
    ))

    if(Number.isInteger(index)) {
      let newConversations = update(
        this.state.conversations,
        { $splice: [[index, 1, receivedConversation]] }
      )

      this.setState({
        conversations: newConversations
      })
    } else {
      this.setState({
        conversations: this.state.conversations.concat([receivedConversation])
      })
    }
  }

  handleFilterChange(filter) {
    this.setState({ filter: filter });
  }
} 

export default Inbox
