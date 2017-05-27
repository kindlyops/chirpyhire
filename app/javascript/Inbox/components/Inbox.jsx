import React from 'react'
import InboxItem from './inboxItem'
import { AutoSizer, List, InfiniteLoader } from 'react-virtualized'

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      loadedRowCount: 0,
      loadedRowsMap: {},
      loadingRowCount: 0,
      randomScrollToIndex: null
    }
  }

  remoteRowCount() {
    return this.props.conversations_count;
  }

  isRowLoaded({ index }) {
    return !!this.state.conversations[index];
  }

  loadMoreRows({ startIndex, stopIndex }) {
    const page = Math.round(((startIndex) / this.pageSize()) + 1);

    return $.get(`/inboxes/1/conversations/page/${page}.json`)
      .then(response => {
        // var conversations = this.state.conversations.conversations.slice();
        // var conversations = R.unionWith(
        //   R.eqBy(R.prop('id')), response, conversations
        // );

        // this.setState({ conversations: conversations });

        R.forEach(conversation => {
          let index = R.findIndex(existingConversation => {
            return existingConversation.id === conversation.id;
          }, this.state.conversations);

          if (index) {
            var state = this.state.conversations.slice();
            state[index] = conversation;
            this.setState({ conversations: state });
          } else {
            var state = this.state.conversations.slice().push(conversation);
            this.setState({ conversations: state });
          }

        }, response);
      });
  }

  pageSize() {
    return 25;
  }

  infiniteLoaderParams() {
    return {
      rowCount: this.remoteRowCount(),
      isRowLoaded: this.isRowLoaded.bind(this),
      loadMoreRows: this.loadMoreRows.bind(this),
      minimumBatchSize: this.pageSize()
    }
  }

  render() {
    return (
      <InfiniteLoader {...this.infiniteLoaderParams()}>
        {({ onRowsRendered, registerChild }) => (
          <div className='autosizer-wrapper'>
            <AutoSizer disableWidth>
              {({ height }) => (
                <List className="Inbox"
                  width={280}
                  height={height}
                  ref={registerChild}
                  rowCount={this.remoteRowCount()}
                  rowHeight={70.59}
                  onRowsRendered={onRowsRendered}
                  rowRenderer={this._rowRenderer.bind(this)}
                />
              )}
            </AutoSizer>
          </div>
        )}
      </InfiniteLoader>
    )
  }

  _rowRenderer({ key, index, style }) {
    return (
      <div key={key} style={style}>
        <InboxItem {...this.state.conversations[index]} />
      </div>
    )
  }
}

export default Inbox
