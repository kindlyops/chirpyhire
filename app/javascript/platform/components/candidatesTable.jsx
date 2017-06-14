import React from 'react'

import { Link } from 'react-router-dom'
import { Column, Table, AutoSizer } from 'react-virtualized'

class CandidatesTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      icons: {
        handle: 'fa-user',
        last_messaged: 'fa-calendar',
        first_messaged: 'fa-calendar'
      },
      candidates: []
    }

    this.messageCellRenderer = this.messageCellRenderer.bind(this);
    this.headerRenderer = this.headerRenderer.bind(this);
    this.cellRenderer = this.cellRenderer.bind(this);
    this.handleCellRenderer = this.handleCellRenderer.bind(this);
  }

  icon(dataKey) {
    return this.state.icons[dataKey];
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

  handleCellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    return (
      <div className='candidateCell'>
        <span className='candidateAvatar mr-2'>
          <span className='candidateAvatarImage'>HW</span>
        </span>
        {cellData}
      </div>
    )
  }

  headerRenderer({ columnData, dataKey, disableSort, label, sortBy, sortDirection }) {
    return (
      <span className='small-caps'>
        <i className={`fa mr-2 ${this.icon(dataKey)}`}></i>
        {label}
      </span>
    )
  }

  componentDidMount() {
    $.get('/candidates/search').then((candidates) => (
      this.setState({ candidates: candidates })
    ))
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
                rowCount={this.state.candidates.length}
                rowGetter={({ index }) => this.state.candidates[index]}
              >
                <Column
                  label='Handle'
                  dataKey='handle'
                  width={150}
                  flexGrow={3}
                  cellRenderer={this.handleCellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={52}
                  label='Message'
                  cellRenderer={this.messageCellRenderer}
                  headerRenderer={() => {}}
                  dataKey='existing_open_conversation_id'
                />
                <Column
                  width={150}
                  label='Last Messaged'
                  dataKey='last_messaged'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={150}
                  label='First Messaged'
                  dataKey='first_messaged'
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
