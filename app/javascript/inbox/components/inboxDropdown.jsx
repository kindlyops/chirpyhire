import React from 'react'
import Select from 'react-select'
import 'react-select/dist/react-select.css'

class InboxDropdown extends React.Component {
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
      { value: 'Closed', label: 'Closed', count: 120, countClassName: 'badge badge-default' },
      { value: 'Open', label: 'Open', count: 3, countClassName: 'badge badge-primary' },
      { value: 'All', label: 'All', count: 123, countClassName: 'badge badge-success' }
    ]
  }

  filterConversations(option) {
    console.log("Selected: " + option.label);
  }

  render() {    
    return (
      <Select
        name="state"
        value="all"
        clearable={false}
        searchable={false}
        className="InboxDropdown"
        options={this.options()}
        arrowRenderer={this.arrowRenderer}
        optionRenderer={this.optionRenderer}
        valueRenderer={this.valueRenderer}
        onChange={this.filterConversations}
      />
    )
  }
}

export default InboxDropdown
