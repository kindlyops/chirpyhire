import React from 'react'
import Conversations from './components/conversations'
import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'
import Conversation from 'conversation'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = { 
      conversations: [],
      filter: 'All'
    };

    this.handleFilterChange = this.handleFilterChange.bind(this);
  }

  inboxId() {
    return this.props.match.params.inboxId;
  }

  id() {
    return this.props.match.params.id;
  }

  conversation() {
    if(this.id()) {
      return <Conversation id={this.id()} inboxId={this.inboxId()} />;
    } else {
      return this.emptyInbox();
    }
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
    return <div className="Inbox">
              <Conversations>
                <ConversationsMenu 
                  filter={this.state.filter}
                  conversations={this.state.conversations}
                  handleFilterChange={this.handleFilterChange}
                />        
                <ConversationsList
                  inboxId={this.inboxId()}
                  filter={this.state.filter}
                  conversations={this.state.conversations}
                 />
              </Conversations>
              {this.conversation()}
            </div>;
  }

  inboxUrl() {
    return `/inboxes/${this.inboxId()}/conversations`;
  }

  componentDidMount() {
    $.get(this.inboxUrl()).then((conversations) => {
      this.setState({ conversations: conversations });
    });
  }

  handleFilterChange(filter) {
    this.setState({ filter: filter });
  }
} 

export default Inbox
