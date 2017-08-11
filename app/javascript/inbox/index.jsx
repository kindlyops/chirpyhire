import React from 'react'
import update from 'immutability-helper'
import moment from 'moment'

import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'
import Conversation from 'conversation'
import Inboxes from './components/inboxes'
import RestartNotificationBar from '../restart_notification_bar'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      subscription: {},
      conversations: [],
      nextPage: 1,
      inboxes: [],
      filter: 'Open'
    };

    this.handleFilterChange = this.handleFilterChange.bind(this);
    this.loadMoreConversations = this.loadMoreConversations.bind(this);
  }

  inboxId() {
    return this.props.match.params.inboxId;
  }

  id() {
    return this.props.match.params.id;
  }

  componentWillReceiveProps(nextProps) {
    if(nextProps.match.params.inboxId !== this.inboxId()) {
      this.load(nextProps.match.params.inboxId);
      this.reconnect(nextProps.match.params.inboxId);
    }
  }

  loadMoreConversations(e) {
    e.preventDefault();

    $.get(this.conversationsURL(this.inboxId(), this.state.nextPage)).then((response) => {
      let new_conversations = update(this.state.conversations, { $push: response.conversations });
      this.setState({ conversations: new_conversations, nextPage: response.next_page });
    });
  }

  conversationComponent() {
    let conversation = this.conversation();

    if (conversation) {
      return <Conversation
                current_account={this.props.current_account}
                conversation={conversation} />
    } else {
      return this.emptyInbox();
    }
  }

  conversation() {
    return R.find((conversation) => (
      parseInt(this.id()) === conversation.id
    ), this.state.conversations);
  }

  conversationsByRecency() {
    return this.state.conversations.sort((first, second) => {
      let firstMoment = moment(first.last_conversation_part_created_at);
      let secondMoment = moment(second.last_conversation_part_created_at);
      let difference = secondMoment - firstMoment;

      if(difference === 0) {
        return first.id - second.id;
      } else {
        return difference;
      }
    })
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
    return <div className='ch--Page Recruit'>
            <RestartNotificationBar {...this.props} />
            <Inboxes current_account={this.props.current_account} inboxes={this.state.inboxes} />
            <div className="Inbox">
              <div className='Conversations'>
                <ConversationsMenu 
                  inboxId={this.inboxId()}
                  filter={this.state.filter}
                  conversations={this.state.conversations}
                  handleFilterChange={this.handleFilterChange}
                />        
                <ConversationsList
                  inboxId={this.inboxId()}
                  loadMoreConversations={this.loadMoreConversations}
                  conversations={this.conversationsByRecency()}
                 />
              </div>
              {this.conversationComponent()}
            </div>
          </div>
  }

  conversationsURL(inboxId, page = 1, filter = 'Open') {
    let baseUrl = `/inboxes/${inboxId}/conversations.json?page=${page}`;

    if (filter !== 'All') {
      return `${baseUrl}&state=${filter}`;
    } else {
      return baseUrl;
    }
  }

  inboxesURL() {
    return `/inboxes`;
  }

  componentDidMount() {
    this.load(this.inboxId());
    this.connect(this.inboxId());
  }

  componentWillUnmount() {
    this.disconnect();
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.subscription);
  }

  load(inboxId) {
    $.get(this.inboxesURL()).then((inboxes) => {
      this.setState({ inboxes: inboxes });
    });
    
    $.get(this.conversationsURL(inboxId, 1, this.state.filter)).then((response) => {
      this.setState({ conversations: response.conversations, nextPage: response.next_page });
    });
  }

  reconnect(inboxId) {
    this.disconnect();
    this.connect(inboxId);
  }

  connect(inboxId) {
    let channel = { channel: 'ConversationsChannel', inbox_id: inboxId };
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
    let index = R.findIndex((conversation) => (
      receivedConversation.id === conversation.id
    ), this.state.conversations)

    if(index !== -1) {
      let new_conversations = update(
        this.state.conversations,
        { $splice: [[index, 1, receivedConversation]] }
      )

      this.setState({
        conversations: new_conversations
      })
    } else {
      this.setState({
        conversations: this.state.conversations.concat([receivedConversation])
      })
    }
  }

  handleFilterChange(filter) {
    this.setState({ filter: filter }, () => {
      $.get(this.conversationsURL(this.inboxId(), 1, this.state.filter)).then((response) => {
        this.setState({ conversations: response.conversations, nextPage: response.next_page });
      });
    });
  }
} 

export default Inbox
