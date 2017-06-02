import React from 'react'
import Conversations from './components/conversations'
import ConversationsList from './components/conversationsList'
import ConversationsMenu from './components/conversationsMenu'

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
