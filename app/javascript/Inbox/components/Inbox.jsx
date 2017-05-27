import React from 'react'
import InboxItem from './inboxItem'
import { AutoSizer, List, InfiniteLoader } from 'react-virtualized'

class Inbox extends React.Component {
  render() {
    return (
      <div className='autosizer-wrapper'>
        <AutoSizer disableWidth>
          {({ height }) => (
            <List className="Inbox"
              width={280}
              height={height}
              rowCount={this.props.conversations.length}
              rowHeight={70.59}
              rowRenderer={this._rowRenderer.bind(this)}
            />
          )}
        </AutoSizer>
      </div>
    )
  }

  _rowRenderer({ key, index, style }) {
    return (
      <div key={key} style={style}>
        <InboxItem {...this.props.conversations[index]} />
      </div>
    )
  }
}

export default Inbox
