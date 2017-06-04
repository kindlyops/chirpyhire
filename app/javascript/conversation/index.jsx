import React from 'react'
import update from 'immutability-helper'
import ConversationChat from './components/conversationChat'
import ConversationProfile from './components/conversationProfile'

class Conversation extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      messageSubscription: {},
      contactSubscription: {},
      conversation: {
        contact: {
          zipcode: {},
          certification: {},
          availability: {},
          live_in: {},
          experience: {},
          transportation: {},
          cpr_first_aid: {},
          skin_test: {}
        },
        messages: []
      }
    };
  }

  render() {
    return (<div className='Conversation'>
      <ConversationChat 
        conversation={this.state.conversation}
      />
      <ConversationProfile 
        contact={this.state.conversation.contact}
        inbox={this.props.inbox}
      />
    </div>);
  }

  conversationUrl(id) {
    return `/inboxes/${this.props.inboxId}/conversations/${id}`;
  }

  componentWillReceiveProps(nextProps) {
    if(nextProps.id !== this.props.id) {
      this.load(nextProps.id);
      this.reconnect(this.props.id);
    }
  }

  componentDidMount() {
    this.load(this.props.id);
    this.connect(this.props.id);
  }

  load(id) {
    $.get(this.conversationUrl(id)).then((conversation) => {
      this.setState({ conversation: conversation });
    });
  }

  connect(id) {
    this._connectMessage(id);
    this._connectContact(id);
  }

  reconnect(id) {
    this.disconnect();
    this.connect(id);
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.messageSubscription);
    App.cable.subscriptions.remove(this.state.contactSubscription);
  }

  _connectMessage(id) {
    let channel = { channel: 'MessagesChannel', conversation_id: id };
    let subscription = App.cable.subscriptions.create(
      channel, this._messageChannelConfig()
    );

    this.setState({ messageSubscription: subscription });
  }

  _connectContact(id) {
    let channel = { channel: 'ContactsChannel', conversation_id: id };
    let subscription = App.cable.subscriptions.create(
      channel, this._contactChannelConfig()
    );

    this.setState({ contactSubscription: subscription });
  }

  _messageChannelConfig() {
    return {
      received: this._messageReceived.bind(this)
    }
  }

  _contactChannelConfig() {
    return {
      received: this._contactReceived.bind(this)
    }
  }

  _messageReceived(receivedMessage) {
    let conversation = update(this.state.conversation, 
      { 
        messages: { $push: [receivedMessage] }
      }
    );

    this.setState({ conversation: conversation });
  }

  _contactReceived(receivedContact) {
    let conversation = update(this.state.conversation, 
      { 
        contact: { $set: receivedContact }
      }
    );

    this.setState({ conversation: conversation });
  }
}

export default Conversation
