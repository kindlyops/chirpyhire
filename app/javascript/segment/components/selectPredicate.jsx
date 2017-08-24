import React from 'react'
import Select from 'react-select'

class SelectPredicate extends React.Component {
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
    if (event === null) {
      this.props.removePredicate(this.props.index);
    } else {
      this.props.onPredicateChange({
        type: this.props.type,
        attribute: this.props.attribute,
        comparison: this.props.comparison,
        value: event.id
      }, this.props.index);
    }
  }

  isChecked(comparison) {
    return this.props.comparison === comparison;
  }

  name() {
    return `${this.props.attribute}-comparison-${this.props.index}`;
  }

  valueName() {
    return `${this.props.attribute}-value-${this.props.index}`;
  }
 
  fieldBuilder(comparison) {
    if (this.isChecked(comparison)) {
      return(
        <div className='filter-build-field'>
          <Select
            labelKey={'name'}
            valueKey={'id'}
            name={this.valueName()}
            options={this.props.options}
            className="predicate-select"
            value={this.props.value}
            onChange={this.onValueChange} />
        </div>
      )
    }
  }

  render() {
    return (
      <div>
        <label className='radio-label'>
          <span className='radio-wrapper'>
            <input type="radio" value="eq" name={this.name()} checked={this.isChecked('eq')} onChange={this.onComparisonChange}/>
          </span>
          <span className='radio-content filter-text'>is</span>
        </label>
        {this.fieldBuilder('eq')}
        <label className='radio-label'>
          <span className='radio-wrapper'>
            <input type="radio" value="not_eq" name={this.name()} checked={this.isChecked('not_eq')} onChange={this.onComparisonChange}/>
          </span>
          <span className='radio-content filter-text'>is not</span>
        </label>
        {this.fieldBuilder('not_eq')}
      </div>
    )
  }
}

SelectPredicate.defaultProps = {
  comparison: 'eq',
  value: ''
}

export default SelectPredicate
