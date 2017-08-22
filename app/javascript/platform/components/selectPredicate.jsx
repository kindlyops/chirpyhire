import React from 'react'
import Select from 'react-select'

class SelectPredicate extends React.Component {
  constructor(props) {
    super(props);

    this.onValueChange = this.onValueChange.bind(this);
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

  name() {
    return `${this.props.attribute}-${this.index}`;
  }

  render() {
    return (
      <div>
        <Select
          labelKey={'name'}
          valueKey={'id'}
          name={this.name()}
          options={this.props.options.map(o => { return { id: o.id.toString(), name: o.name }})}
          className="predicate-select"
          value={this.props.value}
          onChange={this.onValueChange} />
      </div>
    )
  }
}

SelectPredicate.defaultProps = {
  comparison: 'eq',
  value: ''
}

export default SelectPredicate
