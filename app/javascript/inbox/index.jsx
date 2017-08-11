import React from 'react'
import update from 'immutability-helper'
import moment from 'moment'

import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'
import Conversation from 'conversation'
import Inboxes from './components/inboxes'
import RestartNotificationBar from '../restart_notification_bar'
import { withRouter } from 'react-router-dom'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      subscription: {},
      conversations: [],
      nextPage: 1,
      inboxes: [],
      filter: 'Open',
      all: 0,
      open: 0,
      closed: 0
    };

    this.handleFilterChange = this.handleFilterChange.bind(this);
    this.loadMoreConversations = this.loadMoreConversations.bind(this);
    this.upsertConversations = this.upsertConversations.bind(this);
    this.conversation = this.conversation.bind(this);
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

  upsertConversations(oldConversations, newConversations) {
    let newState = oldConversations;

    R.forEach((newConvo) => {
      let index = R.findIndex((oldConvo) => (newConvo.id === oldConvo.id), newState);

      if (index === -1) {
        newState = update(newState, { $push: [newConvo] });
      } else {
        newState = update(newState, { $splice: [[index, 1, newConvo]] })
      }
    }, newConversations);

    this.setState({ conversations: newState });
  }

  loadMoreConversations(e) {
    e.preventDefault();

    $.get(this.conversationsURL(this.inboxId(), this.state.nextPage, this.state.filter)).then((response) => {
      this.upsertConversations(this.state.conversations, response.conversations);
      this.setState({ nextPage: response.next_page });
    });
  }

  conversationComponent() {
    let conversation = this.conversation();

    if (conversation) {
      return <Conversation
                handleFilterChange={this.handleFilterChange}
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

      if(isNaN(difference) || difference === 0) {
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
                  all={this.state.all}
                  closed={this.state.closed}
                  open={this.state.open}
                  filter={this.state.filter}
                  conversations={this.state.conversations}
                  handleFilterChange={this.handleFilterChange}
                />        
                <ConversationsList
                  inboxId={this.inboxId()}
                  filter={this.state.filter}
                  loadMoreConversations={this.loadMoreConversations}
                  nextPage={this.state.nextPage}
                  conversations={this.conversationsByRecency()}
                 />
              </div>
              {this.conversationComponent()}
            </div>
          </div>
  }

  conversationURL(inboxId, id) {
    return `/inboxes/${inboxId}/conversations/${id}`;
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
    this.loadCounts();
    $.get(this.inboxesURL()).then((inboxes) => {
      this.setState({ inboxes: inboxes });
    });

    if (this.id()) {
      $.get(this.conversationURL(inboxId, this.id()) + '.json').then((conversation) => {
        this.setState({ conversations: [conversation], filter: conversation.state }, () => {
          $.get(this.conversationsURL(inboxId, 1, conversation.state)).then((response) => {
            this.upsertConversations(this.state.conversations, response.conversations);
            this.setState({ nextPage: response.next_page });
          });
        });
      });
    } else {
      const { history } = this.props;

      $.get(this.conversationsURL(inboxId, 1, 'Open')).then((response) => {
        history.push(this.conversationURL(this.inboxId(), response.conversations[0].id));
        this.upsertConversations(this.state.conversations, response.conversations);
        this.setState({ filter: 'Open', nextPage: response.next_page });
      });
    }
  }

  loadCounts() {
    $.get(`/inboxes/${this.inboxId()}/conversations_count`).then((all) => {
      this.setState({ all: all });
    });

    $.get(`/inboxes/${this.inboxId()}/conversations_count?state=Open`).then((open) => {
      this.setState({ open: open });
    });

    $.get(`/inboxes/${this.inboxId()}/conversations_count?state=Closed`).then((closed) => {
      this.setState({ closed: closed });
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
    this.upsertConversations(this.state.conversations, [receivedConversation]);
  }

  handleFilterChange(filter) {
    const { history } = this.props;
    let conversation = this.conversation();

    this.loadCounts();
    this.setState({ filter: filter }, () => {
      $.get(this.conversationsURL(this.inboxId(), 1, this.state.filter)).then((response) => {
        if (conversation && conversation.state === filter) {
          this.upsertConversations(this.state.conversations, response.conversations);
        } else {
          if (response.conversations.length) {
            history.push(this.conversationURL(this.inboxId(), response.conversations[0].id));
          }
          this.setState({ conversations: response.conversations });
        }

        this.setState({ nextPage: response.next_page });
      });
    });
  }
} 

export default withRouter(Inbox)
