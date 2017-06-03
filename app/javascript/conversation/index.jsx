import React from 'react'
import ConversationChat from './components/conversationChat'
import ConversationProfile from './components/conversationProfile'

class Conversation extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
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

  conversationUrl() {
    return `/inboxes/${this.props.inboxId}/conversations/${this.props.id}`;
  }

  componentDidMount() {
    $.get(this.conversationUrl()).then((conversation) => {
      this.setState({ conversation: conversation });
    });
  }
}

export default Conversation
