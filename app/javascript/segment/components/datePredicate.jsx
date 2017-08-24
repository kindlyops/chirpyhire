import React from 'react'

class DatePredicate extends React.Component {
  constructor(props) {
    super(props);

    this.onComparisonChange = this.onComparisonChange.bind(this);
    this.onValueChange = this.onValueChange.bind(this);
    this.isChecked = this.isChecked.bind(this);
  }

  onComparisonChange(event) {
    this.props.onPredicateChange({
      type: this.props.type,
      attribute: this.props.attribute,
      comparison: event.target.value,
      value: this.props.value
    }, this.props.index);
  }

  onValueChange(event) {
    this.props.onPredicateChange({
      type: this.props.type,
      attribute: this.props.attribute,
      comparison: this.props.comparison,
      value: event.target.value
    }, this.props.index);
  }

  isChecked(comparison) {
    return this.props.comparison === comparison;
  }

  fieldBuilder(comparison) {
    if (this.isChecked(comparison)) {
      return(
        <div className='filter-build-field'>
          <input
            className='radio-field-input' 
            type="number"
            value={this.props.value}
            name={`value-${this.props.index}`}
            onChange={this.onValueChange} />
          <span className='radio-field-label filter-text'>days ago</span>
        </div>
      )
    }
  }

  name() {
    return `${this.props.attribute}-comparison-${this.props.index}`;
  }

  render() {
    return (
      <div>
        <div className='small-uppercase'>Relative</div>
        <label className='radio-label'>
          <span className='radio-wrapper'>
            <input type="radio" value="gt" name={this.name()} checked={this.isChecked('gt')} onChange={this.onComparisonChange}/>
          </span>
          <span className='radio-content filter-text'>more than</span>
        </label>
        {this.fieldBuilder('gt')}
        <label className='radio-label'>
          <span className='radio-wrapper'>
            <input type="radio" value="eq" name={this.name()} checked={this.isChecked('eq')} onChange={this.onComparisonChange}/>
          </span>
          <span className='radio-content filter-text'>exactly</span>
        </label>
        {this.fieldBuilder('eq')}
        <label className='radio-label'>
          <span className='radio-wrapper'>
            <input type="radio" value="lt" name={this.name()} checked={this.isChecked('lt')} onChange={this.onComparisonChange}/>
          </span>
          <span className='radio-content filter-text'>less than</span>
        </label>
        {this.fieldBuilder('lt')}
      </div>
    )
  }
}

DatePredicate.defaultProps = {
  comparison: 'gt',
  value: ''
}

export default DatePredicate
