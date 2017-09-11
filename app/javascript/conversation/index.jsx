import React from 'react'
import ConversationChat from './components/conversationChat'
import ConversationProfile from './components/conversationProfile'

class Conversation extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      partsSubscription: {},
      contactSubscription: {},
      contact: {
        zipcode: {},
        source: '',
        tags: [],
        contact_stages: [],
        id: '',
        handle: ''
      },
      parts: []
    };
    this.onNameChange = this.onNameChange.bind(this);
    this._partsReceived = this._partsReceived.bind(this)
    this._contactReceived = this._contactReceived.bind(this)
  }

  onNameChange(event) {
    const params = {
      _method: 'put',
      contact: { name: event.target.value }
    };

    const config = {
      url: this.contactUrl(this.state.contact.id),
      data: params,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }

    $.ajax(config);
  }

  render() {
    return (<div className='Conversation'>
      <ConversationChat
        handleFilterChange={this.props.handleFilterChange}
        conversation={this.props.conversation}
        contact={this.state.contact}
        filter={this.props.filter}
        parts={this.state.parts}
      />
      <ConversationProfile
        onNameChange={this.onNameChange}
        contact={this.state.contact}
        inbox={this.props.inbox}
      />
    </div>);
  }

  contactUrl(id) {
    return `/contacts/${id}`;
  }

  partsUrl(id) {
    return `/conversations/${id}/parts`;
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

    $.get(this.partsUrl(conversation.id)).then((parts) => {
      this.setState({ parts: parts });
    });
  }

  connect(conversation) {
    this._connectParts(conversation);
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
    App.cable.subscriptions.remove(this.state.partsSubscription);
    App.cable.subscriptions.remove(this.state.contactSubscription);
  }

  _connectParts(conversation) {
    let channel = { channel: 'PartsChannel', conversation_id: conversation.id };
    let subscription = App.cable.subscriptions.create(
      channel, this._partsChannelConfig()
    );

    this.setState({ partsSubscription: subscription });
  }

  _connectContact(conversation) {
    let channel = { channel: 'ContactsChannel', id: conversation.contact_id };
    let subscription = App.cable.subscriptions.create(
      channel, this._contactChannelConfig()
    );

    this.setState({ contactSubscription: subscription });
  }

  _partsChannelConfig() {
    return {
      received: this._partsReceived
    }
  }

  _contactChannelConfig() {
    return {
      received: this._contactReceived
    }
  }

  _partsReceived(receivedPart) {
    this.setState({
      parts: this.state.parts.concat([receivedPart])
    });
  }

  _contactReceived(receivedContact) {
    this.setState({
      contact: receivedContact
    });
  }
}

export default Conversation
