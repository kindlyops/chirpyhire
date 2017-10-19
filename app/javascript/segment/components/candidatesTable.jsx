import React from 'react'

import { Column, Table, AutoSizer } from 'react-virtualized'

const createCheckboxColumn = props => (
  <Column
    width={56}
    minWidth={56}
    label={props.label}
    dataKey={props.dataKey}
    disableSort={true}
    style={{ minWidth: `${56}px` }}
    cellDataGetter={row => row.rowData}
    cellRenderer={row => (
      <input className='mx-auto'
        type='checkbox'
        checked={props.rowSelected(row)}
        onChange={selected => props.onRowSelect(selected, row)}
      />
    )}
  />
);

class CandidatesTable extends React.Component {
  constructor(props) {
    super(props);

    this.messageCellRenderer = this.messageCellRenderer.bind(this);
    this.headerRenderer = this.headerRenderer.bind(this);
    this.cellRenderer = this.cellRenderer.bind(this);
    this.nameCellRenderer = this.nameCellRenderer.bind(this);
    this.checkboxProps = this.checkboxProps.bind(this);
  }
  
  checkboxProps() {
    return {
      rowSelected: function(row) {
        return row.cellData.selected || false;
      }.bind(this),

      onRowSelect: function(selected, row) {
        row.cellData.selected = selected.target.checked;
        this.props.updateCandidate(row.cellData);
      }.bind(this),
      dataKey: 'selected'
    }
  }

  messageCellRenderer({ cellData, columnData, columnIndex, dataKey, isScrolling, rowData, rowIndex }) {
    if (cellData) {
      return (<a href={`/inboxes/${rowData.inbox_id}/conversations/${cellData}`} className='btn btn-outline-primary'>
        <i className='fa fa-comment'></i>
      </a>);
    } else {
      return (<a href={`/contacts/${rowData.id}/conversations/new`} className='btn btn-outline-primary'>
        <i className='fa fa-comment'></i>
      </a>);
    }
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
                {createCheckboxColumn(this.checkboxProps())}
                <Column
                  label='Name'
                  dataKey='name'
                  width={200}
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
                  width={110}
                  label='Stage'
                  dataKey='stage'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={110}
                  label='Source'
                  dataKey='source'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={200}
                  label='Last Seen'
                  dataKey='last_seen_at_ago'
                  cellRenderer={this.cellRenderer}
                  headerRenderer={this.headerRenderer}
                />
                <Column
                  width={200}
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
