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

  inboxId() {
    return this.props.inboxId;
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
      { value: 'Closed', label: 'Closed', count: this.props.closed, countClassName: 'badge badge-dark' },
      { value: 'Open', label: 'Open', count: this.props.open, countClassName: 'badge badge-primary' },
      { value: 'All', label: 'All', count: this.props.all, countClassName: 'badge badge-success' }
    ]
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
