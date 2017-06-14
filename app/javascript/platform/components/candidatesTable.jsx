import React from 'react'

import { Link } from 'react-router-dom'
import { Column, Table, AutoSizer } from 'react-virtualized'

class CandidatesTable extends React.Component {
  constructor(props) {
    super(props);

    this.messageCellRenderer = this.messageCellRenderer.bind(this);
    this.headerRenderer = this.headerRenderer.bind(this);
    this.cellRenderer = this.cellRenderer.bind(this);
    this.nicknameCellRenderer = this.nicknameCellRenderer.bind(this);
  }

  messageCellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    return (
      <Link to={`/inboxes/1/conversations/${cellData}`} className='btn btn-outline-primary'>
        <i className='fa fa-comment'></i>
      </Link>
    )
  }

  cellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    return (
      <div className='candidateCell'>{cellData}</div>
    )
  }

  nicknameCellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
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
      <span className='small-caps'>
        {label}
      </span>
    )
  }

  initials(nickname) {
    return nickname.split(' ').map(function (s) { return s.charAt(0); }).join('');
  }

  render() {
    return (
      <div className='CandidatesTable'>
        <div className='autosizer-wrapper'>  
          <AutoSizer>
            {({ height }) => (  
              <Table
                width={1200}
                height={height}
                headerHeight={50}
                rowHeight={40}
                rowCount={this.props.candidates.length}
                rowGetter={({ index }) => this.props.candidates[index]}
              >
                <Column
                  label='Nickname'
                  dataKey='nickname'
                  width={260}
                  flexGrow={2}
                  cellRenderer={this.nicknameCellRenderer}
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
                  width={150}
                  label='Certification'
                  dataKey='certification'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={150}
                  label='Experience'
                  dataKey='experience'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={100}
                  label='Zipcode'
                  dataKey='zipcode'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={120}
                  label='Availability'
                  dataKey='availability'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={170}
                  label='Last Seen'
                  dataKey='last_seen_at_ago'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={170}
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
