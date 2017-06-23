import React from 'react'
import Select from 'react-select'

class CandidateFilter extends React.Component {
  constructor(props) {
    super(props);

    this.valueRenderer = this.valueRenderer.bind(this);
    this.optionRenderer = this.optionRenderer.bind(this);
    this.handleSelectChange = this.handleSelectChange.bind(this);
  }

  valueRenderer(option) {
    return (
      <div className='filter-value d-flex align-items-center'>
        <i className={`fa mr-2 ${option.icon}`}></i>
        <span>{option.label}</span>
      </div>
    )
  }

  optionRenderer(option) {
    return (
      <div className='filter-option'>
        <i className={`fa mr-2 ${option.icon}`}></i>
        {option.label}
      </div>
    )
  }

  predicate() {
    if(this.isChecked()) {
      return (
        <div className='predicate'>
          <div className='predicate-inner'>
            <Select
              multi={true}
              name={this.name()}
              options={this.props.tags}
              className="predicate-select"
              value={this.value()}
              optionRenderer={this.optionRenderer}
              valueRenderer={this.valueRenderer}
              onChange={this.handleSelectChange}
            />
          </div>
        </div>
      )
    }
  }

  isChecked() {
    return this.props.form[this.name()] || this.props.checked;
  }

  value() {
    let value = this.props.form[this.name()];

    if (value) {
      if (Array.isArray(value)) {
        return value.join(',');
      } else {
        return value;
      }
    } else {
      return '';
    }
  }

  handleSelectChange(options) {
    const value = options && options.map(o => o.value);
    const filter = this.name();
    this.props.handleSelectChange({ value: value, filter: filter });
  }

  name() {
    return this.props.attribute.toLowerCase();
  }

  render() {
    return (
      <div className='CandidateFilter'>
        <div className='form-check small-caps'>
          <label className='form-check-label'>
            <input className='form-check-input' name={this.name()} type="checkbox" onChange={this.props.toggle} checked={this.isChecked()} value="" />
            <i className={`fa fa-fw mr-1 ml-1 ${this.props.icon}`}></i>
            {` ${this.props.attribute}`}
          </label>
        </div>
        {this.predicate()}
      </div>
    )
  }
}

export default CandidateFilter
