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
    this._connectMessage(conversation);
    this._connectContact(conversation);
  }

  reconnect(conversation) {
    this.disconnect();
    this.connect(conversation);
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.messageSubscription);
    App.cable.subscriptions.remove(this.state.contactSubscription);
  }

  _connectMessage(conversation) {
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
      received: this._messageReceived.bind(this)
    }
  }

  _contactChannelConfig() {
    return {
      received: this._contactReceived.bind(this)
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
