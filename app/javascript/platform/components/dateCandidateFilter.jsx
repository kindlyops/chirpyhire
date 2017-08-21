import React from 'react'

class DateCandidateFilter extends React.Component {
  constructor(props) {
    super(props);
  }

  predicate() {
    if(this.isChecked()) {
      return (
        <div className='predicate'>
          <div className='predicate-inner'>
            <div className='small-uppercase'>Relative</div>
            <label className='radio-label'>
              <span className='radio-wrapper'>
                <input type="radio" value="" name=""/>
              </span>
              <span className='radio-content filter-text'>more than</span>
            </label>
            <label className='radio-label'>
              <span className='radio-wrapper'>
                <input type="radio" value="" name=""/>
              </span>
              <span className='radio-content filter-text'>exactly</span>
            </label>
            <label className='radio-label'>
              <span className='radio-wrapper'>
                <input type="radio" value="" name=""/>
              </span>
              <span className='radio-content filter-text'>less than</span>
            </label>
          </div>
        </div>
      )
    }
  }

  value() {
    if (!this.props.form.q) return '';

    return this.props.form.q[`${this.name()}_count_eq`] || '';
  }

  isChecked() {
    let query = this.props.form.q;

    return query && query[`${this.name()}_count_eq`] || this.props.checked;
  }

  name() {
    return this.props.name || this.props.attribute.toLowerCase();
  }

  render() {
    return (
      <div className='CandidateFilter'>
        <div className='form-check small-uppercase'>
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

export default DateCandidateFilter
