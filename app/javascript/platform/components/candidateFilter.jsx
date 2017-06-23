import React from 'react'
import Select from 'react-select'

class CandidateFilter extends React.Component {
  constructor(props) {
    super(props);
    this.handleSelectChange = this.handleSelectChange.bind(this);
  }

  predicate() {
    if(this.isChecked()) {
      return (
        <div className='predicate'>
          <div className='predicate-inner'>
            <Select
              labelKey={'name'}
              valueKey={'id'}
              multi={true}
              name={this.name()}
              options={this.props.options.map(o => { return { id: o.id.toString(), name: o.name }})}
              className="predicate-select"
              value={this.value()}
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
      return value.join(',');
    }
  }

  handleSelectChange(options) {
    const value = options && options.map(o => o.id);
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
