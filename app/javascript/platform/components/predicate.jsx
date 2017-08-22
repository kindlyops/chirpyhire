import React from 'react'
import DatePredicate from './datePredicate'
import SelectPredicate from './selectPredicate'
import IntegerPredicate from './integerPredicate'
import StringPredicate from './stringPredicate'

class Predicate extends React.Component {
  typePredicate() {
    switch(this.props.type) {
      case 'date':
        return <DatePredicate {...this.props} />;
        break;
      case 'select':
        return <SelectPredicate {...this.props} />;
        break;
      case 'integer':
        return <IntegerPredicate {...this.props} />;
        break;
      case 'string':
        return <StringPredicate {...this.props} />;
        break;
    }
  }

  render() {
    return (
      <div className='predicate'>
        <div className='predicate-inner'>
          {this.typePredicate()}
        </div>
      </div>
    )
  }
}

export default Predicate
