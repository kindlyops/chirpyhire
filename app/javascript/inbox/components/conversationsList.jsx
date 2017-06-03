import React from 'react'
import InboxItem from './inboxItem'
import { AutoSizer, List } from 'react-virtualized'

class ConversationsList extends React.Component {
  constructor(props) {
    super(props);
    this._rowRenderer = this._rowRenderer.bind(this);
    this._byState = this._byState.bind(this);
  }

  render() {    
    return (
      <div className='autosizer-wrapper'>
        <AutoSizer disableWidth>
          {({ height }) => (
            <List className="ConversationsList"
              width={280}
              height={height}
              rowCount={this.rowCount()}
              rowHeight={70.59}
              rowRenderer={this._rowRenderer}
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
        <InboxItem inboxId={this.props.inboxId} {...conversations[index]} />
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

export default ConversationsList
