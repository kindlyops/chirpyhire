import React from 'react'
import update from 'immutability-helper'
import ConversationChat from './components/conversationChat'
import ConversationProfile from './components/conversationProfile'

class Conversation extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      subscription: {},
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

  channelConfig() {
    return {
      received: this.received.bind(this)
    }
  }

  connect(id) {
    let channel = { channel: 'MessagesChannel', conversation_id: id };
    let subscription = App.cable.subscriptions.create(
      channel, this.channelConfig()
    );

    this.setState({ subscription: subscription });
  }

  reconnect(id) {
    App.cable.subscriptions.remove(this.state.subscription);
    this.connect(id);
  }

  received(receivedMessage) {
    let conversation = update(this.state.conversation, 
      { 
        messages: { $push: [receivedMessage] }
      }
    );

    this.setState({ conversation: conversation });
  }
}

export default Conversation
