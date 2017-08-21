import React from 'react'

class DateCandidateFilter extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: props.value || ''
    }
    this.onChange = this.onChange.bind(this);
    this.isRadioChecked = this.isRadioChecked.bind(this);
    this.fieldBuilder = this.fieldBuilder.bind(this);
  }

  predicate() {
    if(this.isChecked()) {
      return (
        <div className='predicate'>
          <div className='predicate-inner'>
            <div className='small-uppercase'>Relative</div>
            <label className='radio-label'>
              <span className='radio-wrapper'>
                <input type="radio" value="_gt_days_ago" name={this.name()} checked={this.isRadioChecked('_gt_days_ago')} onChange={this.onChange}/>
              </span>
              <span className='radio-content filter-text'>more than</span>
            </label>
            {this.fieldBuilder('_gt_days_ago')}
            <label className='radio-label'>
              <span className='radio-wrapper'>
                <input type="radio" value="_eq_days_ago" name={this.name()} checked={this.isRadioChecked('_eq_days_ago')} onChange={this.onChange}/>
              </span>
              <span className='radio-content filter-text'>exactly</span>
            </label>
            {this.fieldBuilder('_eq_days_ago')}
            <label className='radio-label'>
              <span className='radio-wrapper'>
                <input type="radio" value="_lt_days_ago" name={this.name()} checked={this.isRadioChecked('_lt_days_ago')} onChange={this.onChange}/>
              </span>
              <span className='radio-content filter-text'>less than</span>
            </label>
            {this.fieldBuilder('_lt_days_ago')}
          </div>
        </div>
      )
    }
  }

  isRadioChecked(value) {
    let key = `${this.name()}${value}`;
    let query = this.props.form.q;

    return query && query[key] || this.state.value === value;
  }

  onChange(event) {
    this.setState({ value: event.target.value });
  }

  fieldBuilder(value) {
    if (this.isRadioChecked(value)) {
      return(
        <div className='filter-build-field'>
          <input 
            className='radio-field-input' 
            type="number" 
            value={this.inputValue(value)} 
            name={`${this.name()}${value}`} 
            data-field={this.name()}
            onChange={this.props.handleDateChange} />
          <span className='radio-field-label filter-text'>days ago</span>
        </div>
      )
    }
  }

  inputValue(value) {
    if (!this.props.form.q) return '';

    let key = `${this.name()}${value}`;
    return this.props.form.q[key] || '';
  }

  isChecked() {
    let query = this.props.form.q;
    let nameKeys = [];

    if (query) {
      nameKeys = _.filter(_.keys(query), (key) => key.match(this.name()));
    }

    return nameKeys.length > 0 || this.props.checked;
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
