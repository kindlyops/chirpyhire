import React from 'react'
import Select from 'react-select'

class ConversationsMenu extends React.Component {
  constructor(props) {
    super(props);

    this.filterConversations = this.filterConversations.bind(this);
    this.optionRenderer = this.optionRenderer.bind(this);
    this.valueRenderer = this.valueRenderer.bind(this);
    this.arrowRenderer = this.arrowRenderer.bind(this);
  }

  valueRenderer(option) {
    return (
      <div className="view-title">
        <div className="view-count">
          <span className={option.countClassName}>{option.count}</span>
        </div>
        <div className="view-name">{option.label}</div>
      </div>
    )
  }

  optionRenderer(option) {
    return (
      <div className="view-title">
        <div className="view-count">
          <span className={option.countClassName}>{option.count}</span>
        </div>
        <div className="view-name">{option.label}</div>
      </div>
    )
  }

  arrowRenderer({ onMouseDown, isOpen }) {
    return (
      <i className='fa fa-angle-down'></i>
    )
  }

  options() {
    return [
      { value: 'Closed', label: 'Closed', count: this.closedConversationsCount(), countClassName: 'badge badge-default' },
      { value: 'Open', label: 'Open', count: this.openConversationsCount(), countClassName: 'badge badge-primary' },
      { value: 'All', label: 'All', count: this.conversationsCount(), countClassName: 'badge badge-success' }
    ]
  }

  closedConversationsCount() {
    let isClosed = ((conversation) => conversation.state === 'Closed');
    return this.props.conversations.filter(isClosed).length;
  }

  openConversationsCount() {
    let isOpen = ((conversation) => conversation.state === 'Open');
    return this.props.conversations.filter(isOpen).length;
  }
  
  conversationsCount() {
    return this.props.conversations.length;
  }

  filterConversations(option) {
    this.props.handleFilterChange(option.value);
  }

  render() {    
    return (
      <Select
        name="state"
        value={this.props.filter}
        clearable={false}
        searchable={false}
        className="ConversationsMenu"
        options={this.options()}
        arrowRenderer={this.arrowRenderer}
        optionRenderer={this.optionRenderer}
        valueRenderer={this.valueRenderer}
        onChange={this.filterConversations}
      />
    )
  }
}

export default ConversationsMenu
