import React from 'react'
import Select from 'react-select'
import 'react-select/dist/react-select.css'

class InboxDropdown extends React.Component {
  constructor(props) {
    super(props);

    this.logChange = this.logChange.bind(this);
    this.optionRenderer = this.optionRenderer.bind(this);
    this.valueRenderer = this.valueRenderer.bind(this);
  }

  valueRenderer(option) {
    return (
      <div className="view-title">
        <div className="view-count">
          <span className='badge badge-default'>{option.count}</span>
        </div>
        <div className="view-name">{option.label}</div>
      </div>
    )
  }

  optionRenderer(option) {
    return (
      <div className="view-title">
        <div className="view-count">
          <span className='badge badge-default'>{option.count}</span>
        </div>
        <div className="view-name">{option.label}</div>
      </div>
    )
  }

  options() {
    return [
      { value: 'closed', label: 'Closed', count: 120 },
      { value: 'open', label: 'Open', count: 3 },
      { value: 'all', label: 'All', count: 123 }
    ]
  }

  logChange(option) {
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
        optionRenderer={this.optionRenderer}
        valueRenderer={this.valueRenderer}
        onChange={this.logChange}
      />
    )
  }
}

export default InboxDropdown
