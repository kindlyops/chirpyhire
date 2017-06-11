import React from 'react'
import Select from 'react-select'

class CandidateFilter extends React.Component {
  constructor(props) {
    super(props);

    this.valueRenderer = this.valueRenderer.bind(this);
    this.optionRenderer = this.optionRenderer.bind(this);
  }
  valueRenderer(option) {
    return (
      <div className='filter-option d-flex'>
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

  render() {
    return (
      <div className='CandidateFilter'>
        <div className='form-check small-caps'>
          <label className='form-check-label'>
            <input className='form-check-input' type="checkbox" value="" />
            <i className={`fa fa-fw mr-1 ml-1 ${this.props.icon}`}></i>
            {` ${this.props.attribute}`}
          </label>
        </div>

        <div className='predicate'>
          <div className='predicate-buttons'>
            <span className='close-predicate'>
              <i className='fa fa-times'></i>
            </span>
          </div>

          <div className='predicate-inner'>
            <Select
              name={this.props.attribute}
              options={this.props.options}
              className="predicate-select"
              optionRenderer={this.optionRenderer}
              valueRenderer={this.valueRenderer}
            />
            <div className='spacer-10'></div>
          </div>
        </div>
      </div>
    )
  }
}

export default CandidateFilter
