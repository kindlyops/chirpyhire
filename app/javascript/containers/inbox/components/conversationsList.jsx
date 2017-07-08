import React from 'react'
import InboxItem from './inboxItem'
import { AutoSizer, List } from 'react-virtualized'
import { withRouter } from 'react-router-dom'

class ConversationsList extends React.Component {
  constructor(props) {
    super(props);
    this._rowRenderer = this._rowRenderer.bind(this);
    this._byState = this._byState.bind(this);
  }

  render() {    
    return (
      <div className='autosizer-wrapper'>
        <AutoSizer location={this.props.location} disableWidth conversations={this.props.conversations}>
          {({ height }) => (
            <List 
              location={this.props.location}
              className="ConversationsList"
              width={280}
              height={height}
              rowCount={this.rowCount()}
              rowHeight={70.59}
              rowRenderer={this._rowRenderer}
              conversations={this.props.conversations}
            />
          )}
        </AutoSizer>
      </div>
    )
  }

  _rowRenderer({ key, index, style }) {
    let conversations = this.filteredConversations();

    return (
      <div key={key} style={style}>
        <InboxItem 
          location={this.props.location}
          match={this.props.match}
          inboxId={this.props.inboxId}
          {...conversations[index]} />
      </div>
    )
  }

  rowCount() {
    return this.filteredConversations().length;
  }

  filteredConversations() {
    let filter;

    if (this.props.filter === 'All') {
      return this.props.conversations;
    } else {
      return this.props.conversations.filter(this._byState);
    }
  }

  _byState(conversation) {
    return this.props.filter === conversation.state;
  }
}

export default withRouter(ConversationsList)
