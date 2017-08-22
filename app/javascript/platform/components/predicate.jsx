import React from 'react'
import DatePredicate from './datePredicate'
import TagPredicate from './tagPredicate'
import ManualMessagePredicate from './manualMessagePredicate'
import IntegerPredicate from './integerPredicate'
import StringPredicate from './stringPredicate'

class Predicate extends React.Component {
  constructor(props) {
    super(props);
  }

  typePredicate() {
    switch(this.props.type) {
      case 'date':
        return <DatePredicate />;
        break;
      case 'tag':
        return <TagPredicate />;
        break;
      case 'manual_message':
        return <ManualMessagePredicate />;
        break;
      case 'integer':
        return <IntegerPredicate />;
        break;
      case 'string':
        return <StringPredicate />;
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
