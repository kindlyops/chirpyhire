import React from 'react'
import update from 'immutability-helper'
import moment from 'moment'

import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'
import Inboxes from './components/inboxes'
import Conversation from 'conversation'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      subscription: {},
      inbox_conversations: [],
      inbox: {},
      team_inboxes: [],
      filter: 'Open'
    };

    this.handleFilterChange = this.handleFilterChange.bind(this);
  }

  currentFilter() {
    let inbox_conversation = this.conversation();

    if(inbox_conversation) {
      return inbox_conversation.state;
    } else {
      return 'Open';
    }
  }

  inboxId() {
    return this.props.match.params.inboxId;
  }

  id() {
    return this.props.match.params.id;
  }

  conversationComponent() {
    let inbox_conversation = this.conversation();

    if (inbox_conversation) {
      return <Conversation 
                current_account={this.props.current_account}
                inbox_conversation={inbox_conversation}
                inbox={this.state.inbox} />
    } else {
      return this.emptyInbox();
    }
  }

  conversation() {
    return R.find((inbox_conversation) => (
      parseInt(this.id()) === inbox_conversation.conversation_id
    ), this.state.inbox_conversations);
  }

  inboxConversationsByRecency() {
    return this.state.inbox_conversations.sort((first, second) => {
      let firstMoment = moment(first.last_message_created_at);
      let secondMoment = moment(second.last_message_created_at);
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
    return <div className="Recruit">
              <Inboxes inbox={this.state.inbox} team_inboxes={this.state.team_inboxes} />
              <div className="Inbox">
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
                {this.conversationComponent()}
              </div>
          </div>;
  }

  inboxConversationsURL() {
    return `/inboxes/${this.inboxId()}/inbox_conversations`;
  }

  inboxURL() {
    return `/inboxes/${this.inboxId()}`;
  }

  teamInboxesURL() {
    return `/team_inboxes`;
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

    $.get(this.teamInboxesURL()).then((team_inboxes) => {
      this.setState({ team_inboxes: team_inboxes });
    });
    
    $.get(this.inboxConversationsURL()).then((inbox_conversations) => {
      this.setState({ inbox_conversations: inbox_conversations });
      this.setState({ filter: this.currentFilter() });
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
    let index = R.findIndex((inbox_conversation) => (
      receivedInboxConversation.id === inbox_conversation.id
    ), this.state.inbox_conversations)

    if(index !== -1) {
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
