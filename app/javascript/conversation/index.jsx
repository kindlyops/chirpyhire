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
        tags: [],
        outcomes: []
      },
      messages: []
    };

    this._messageReceived = this._messageReceived.bind(this)
    this._contactReceived = this._contactReceived.bind(this)
  }

  render() {
    return (<div className='Conversation'>
      <ConversationChat
        conversation={this.props.conversation}
        contact={this.state.contact}
        messages={this.state.messages}
      />
      <ConversationProfile 
        contact={this.state.contact}
        inbox={this.props.inbox}
        current_account={this.props.current_account}
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
    if(nextProps.conversation.id !== this.props.conversation.id) {
      this.load(nextProps.conversation);
      this.reconnect(nextProps.conversation);
    }
  }

  componentDidMount() {
    this.load(this.props.conversation);
    this.connect(this.props.conversation);
  }

  load(conversation) {
    $.get(this.contactUrl(conversation.contact_id)).then((contact) => {
      this.setState({ contact: contact });
    });    

    $.get(this.messagesUrl(conversation.id)).then((messages) => {
      this.setState({ messages: messages });
    });
  }

  connect(conversation) {
    this._connectMessages(conversation);
    this._connectContact(conversation);
  }

  reconnect(conversation) {
    this.disconnect();
    this.connect(conversation);
  }

  componentWillUnmount() {
    this.disconnect();
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.messageSubscription);
    App.cable.subscriptions.remove(this.state.contactSubscription);
  }

  _connectMessages(conversation) {
    let channel = { channel: 'MessagesChannel', conversation_id: conversation.id };
    let subscription = App.cable.subscriptions.create(
      channel, this._messageChannelConfig()
    );

    this.setState({ messageSubscription: subscription });
  }

  _connectContact(conversation) {
    let channel = { channel: 'ContactsChannel', id: conversation.contact_id };
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
      messages: this.state.messages.concat([receivedMessage])
    });
  }

  _contactReceived(receivedContact) {
    this.setState({
      contact: receivedContact
    });
  }
}

export default Conversation
