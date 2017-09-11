import React from 'react'

class StringPredicate extends React.Component {
  constructor(props) {
    super(props);

    this.onValueChange = this.onValueChange.bind(this);
  }

  onValueChange(event) {
    this.props.onPredicateChange({
      type: this.props.type,
      attribute: this.props.attribute,
      comparison: this.props.comparison,
      value: event.target.value
    }, this.props.index);
  }

  name() {
    return `${this.props.attribute}-${this.props.index}`;
  }

  moveToEnd(event) {
    var temp_value = event.target.value;
    event.target.value = '';
    event.target.value = temp_value;
  }

  render() {
    return (
      <div>
        <input
          autoFocus
          className='Text-input' 
          type="text" 
          name={this.name()} 
          value={this.props.value}
          onFocus={this.moveToEnd}
          onChange={this.onValueChange} />
      </div>
    )
  }
}

StringPredicate.defaultProps = {
  comparison: 'cont',
  value: ''
}

export default StringPredicate
