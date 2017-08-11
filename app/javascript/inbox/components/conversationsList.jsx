import React from 'react'
import InboxItem from './inboxItem'
import { AutoSizer, List } from 'react-virtualized'
import { withRouter } from 'react-router-dom'
import LoadMoreConversations from './loadMoreConversations'

class ConversationsList extends React.Component {
  constructor(props) {
    super(props);
    this._rowRenderer = this._rowRenderer.bind(this);
    this._byState = this._byState.bind(this);
    this.conversations = this.conversations.bind(this);
  }

  render() {    
    return (
      <div className='autosizer-wrapper'>
        <AutoSizer location={this.props.location} disableWidth conversations={this.conversations()}>
          {({ height }) => (
            <List 
              location={this.props.location}
              className="ConversationsList"
              width={280}
              height={height}
              rowCount={this.rowCount()}
              rowHeight={70.59}
              rowRenderer={this._rowRenderer}
              conversations={this.conversations()}
            />
          )}
        </AutoSizer>
      </div>
    )
  }

  _rowRenderer({ key, index, style }) {
    let conversations = this.filteredConversations();
    let content;

    if (conversations[index]) {
      content = (<InboxItem 
          location={this.props.location}
          match={this.props.match}
          inboxId={this.props.inboxId}
          {...conversations[index]} />);
    } else {
      content = (<LoadMoreConversations onClick={this.props.loadMoreConversations} />);
    }

    return (
      <div key={key} style={style}>
        {content}
      </div>
    )
  }

  rowCount() {
    return this.filteredConversations().length + 1;
  }

  _byState(conversation) {
    return this.props.filter === conversation.state;
  }

  filteredConversations() {
    let filter;
    if (this.props.filter === 'All') {
      return this.props.conversations;
    } else {
      return this.props.conversations.filter(this._byState);
    }
  }

  conversations() {
    return this.props.conversations;
  }
}

export default withRouter(ConversationsList)
