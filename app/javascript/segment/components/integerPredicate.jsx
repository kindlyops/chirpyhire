import React from 'react'

class IntegerPredicate extends React.Component {
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

  render() {
    return (
      <div>
        <input 
          className='Text-input' 
          type="number" 
          name={this.name()} 
          value={this.props.value} 
          onChange={this.onValueChange} />
      </div>
    )
  }
}

IntegerPredicate.defaultProps = {
  comparison: 'eq',
  value: ''
}

export default IntegerPredicate
