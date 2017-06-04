import React from 'react'
import ConversationChat from './components/conversationChat'
import ConversationProfile from './components/conversationProfile'

class Conversation extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      messageSubscription: {},
      contactSubscription: {},
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
    };

    this._messageReceived = this._messageReceived.bind(this)
    this._contactReceived = this._contactReceived.bind(this)
  }

  render() {
    return (<div className='Conversation'>
      <ConversationChat 
        contact={this.state.contact}
        messages={this.state.messages}
      />
      <ConversationProfile 
        contact={this.state.contact}
        inbox={this.props.inbox}
      />
    </div>);
  }

  contactUrl(id) {
    return `/contacts/${id}`;
  }

  messagesUrl(id) {
    return `/conversations/${id}/messages`;
  }

  componentWillReceiveProps(nextProps) {
    if(nextProps.inbox_conversation.id !== this.props.inbox_conversation.id) {
      this.load(nextProps.inbox_conversation);
      this.reconnect(nextProps.inbox_conversation);
    }
  }

  componentDidMount() {
    this.load(this.props.inbox_conversation);
    this.connect(this.props.inbox_conversation);
  }

  load(inbox_conversation) {
    $.get(this.contactUrl(inbox_conversation.contact_id)).then((contact) => {
      this.setState({ contact: contact });
    });    

    $.get(this.messagesUrl(inbox_conversation.conversation_id)).then((messages) => {
      this.setState({ messages: messages });
    });
  }

  connect(inbox_conversation) {
    this._connectMessages(inbox_conversation);
    this._connectContact(inbox_conversation);
  }

  reconnect(inbox_conversation) {
    this.disconnect();
    this.connect(inbox_conversation);
  }

  componentWillUnmount() {
    this.disconnect();
  }

  _connectMessages(inbox_conversation) {
    let channel = { channel: 'MessagesChannel', conversation_id: inbox_conversation.conversation_id };
    let subscription = App.cable.subscriptions.create(
      channel, this._messageChannelConfig()
    );

    this.setState({ messageSubscription: subscription });
  }

  _connectContact(inbox_conversation) {
    let channel = { channel: 'ContactsChannel', id: inbox_conversation.contact_id };
    let subscription = App.cable.subscriptions.create(
      channel, this._contactChannelConfig()
    );

    this.setState({ contactSubscription: subscription });
  }

  _messageChannelConfig() {
    return {
      received: this._messageReceived
    }
  }

  _contactChannelConfig() {
    return {
      received: this._contactReceived
    }
  }

  _messageReceived(receivedMessage) {
    this.setState({
      messages: this.state.messages.concat(receivedMessage)
    });
  }

  _contactReceived(receivedContact) {
    this.setState({
      contact: receivedContact
    });
  }
}

export default Conversation
