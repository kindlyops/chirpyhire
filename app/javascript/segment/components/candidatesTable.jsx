import React from 'react'

import { Column, Table, AutoSizer } from 'react-virtualized'

class CandidatesTable extends React.Component {
  constructor(props) {
    super(props);

    this.messageCellRenderer = this.messageCellRenderer.bind(this);
    this.headerRenderer = this.headerRenderer.bind(this);
    this.cellRenderer = this.cellRenderer.bind(this);
    this.nameCellRenderer = this.nameCellRenderer.bind(this);
  }

  messageCellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    return (
      <a href={`/inboxes/${rowData.inbox_id}/conversations/${cellData}`} className='btn btn-outline-primary'>
        <i className='fa fa-comment'></i>
      </a>
    )
  }

  cellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    return (
      <div className='candidateCell'>{cellData}</div>
    )
  }

  nameCellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    return (
      <div className='candidateCell'>
        <span className='candidateAvatar mr-2'>
          <span className={`candidateAvatarImage ${rowData.hero_pattern_classes}`}>{this.initials(cellData)}</span>
        </span>
        {cellData}
      </div>
    )
  }

  headerRenderer({ columnData, dataKey, disableSort, label, sortBy, sortDirection }) {
    return (
      <span className='small-uppercase'>
        {label}
      </span>
    )
  }

  initials(name) {
    let names = name.split(' ');
    let last = names.length - 1;
    names = [names[0], names[last]];
    return names.map(function (s) { return s.charAt(0).toUpperCase(); }).join('');
  }

  render() {
    return (
      <div className='CandidatesTable'>
        <div className='autosizer-wrapper'>  
          <AutoSizer>
            {({ height, width }) => (  
              <Table
                width={width}
                height={height}
                headerHeight={50}
                rowHeight={40}
                rowCount={this.props.candidates.length}
                rowGetter={({ index }) => this.props.candidates[index]}
              >
                <Column
                  label='Name'
                  dataKey='name'
                  width={260}
                  flexGrow={2}
                  cellRenderer={this.nameCellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={52}
                  label='Message'
                  cellRenderer={this.messageCellRenderer}
                  headerRenderer={() => {}}
                  dataKey='current_conversation_id'
                />
                <Column
                  width={100}
                  label='Stage'
                  dataKey='stage'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={240}
                  label='Last Seen'
                  dataKey='last_seen_at_ago'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={240}
                  label='First Seen'
                  dataKey='first_seen_at_ago'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
              </Table>
            )}
          </AutoSizer>
        </div>
      </div>
    )
  }
}

export default CandidatesTable
