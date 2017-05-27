import React from 'react'
import InboxItem from './inboxItem'
import { AutoSizer, List, InfiniteLoader } from 'react-virtualized'

const STATUS_LOADING = 1
const STATUS_LOADED = 2

class Inbox extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      loadedRowCount: 0,
      loadedRowsMap: {},
      loadingRowCount: 0
    }

    this._isRowLoaded = this._isRowLoaded.bind(this)
    this._loadMoreRows = this._loadMoreRows.bind(this)
    this._rowRenderer = this._rowRenderer.bind(this)
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
    const { loadedRowsMap } = this.state;
    const { conversations } = this.props;
    let content;

    if (loadedRowsMap[index] === STATUS_LOADED) {
      content = <InboxItem {...conversations[index]} />;
    } else {
      content = <div className='conversation-placeholder' />;
    }

    return (
      <div key={key} style={style}>
        {content}
      </div>
    )
  }

  _loadMoreRows({ startIndex, stopIndex }) {
    const { loadedRowsMap, loadingRowCount } = this.state;
    const { inboxId } = this.props;
    const increment = stopIndex - startIndex + 1;

    for (var i = startIndex; i <= stopIndex; i++) {
      loadedRowsMap[i] = STATUS_LOADING;
    }

    this.setState({
      loadingRowCount: loadingRowCount + increment
    });

    const page = Math.round(((startIndex) / this.pageSize()) + 1);
    return $.get(`/inboxes/${inboxId}/conversations/page/${page}.json`)
            .then(response => { 
              const { loadedRowCount, loadingRowCount } = this.state

              for (var i = startIndex; i <= stopIndex; i++) {
                loadedRowsMap[i] = STATUS_LOADED
              }

              var conversations = this.props.conversations.concat(response);

              this.setState({
                loadingRowCount: loadingRowCount - increment,
                loadedRowCount: loadedRowCount + increment
              });

              this.props.onConversationsChange(conversations);
            });
  }

  infiniteLoaderParams() {
    return {
      rowCount: this.remoteRowCount(),
      isRowLoaded: this._isRowLoaded,
      loadMoreRows: this._loadMoreRows,
      minimumBatchSize: this.pageSize(),
      threshold: this.pageSize()
    }
  }

  remoteRowCount() {
    return this.props.conversations_count;
  }

  _isRowLoaded({ index }) {
    const { loadedRowsMap } = this.state
    return !!loadedRowsMap[index];
  }

  pageSize() {
    return 25;
  }
}

export default Inbox
