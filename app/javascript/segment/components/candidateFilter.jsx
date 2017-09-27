import React from 'react'
import Predicate from './predicate'
import update from 'immutability-helper'

class CandidateFilter extends React.Component {
  constructor(props) {
    super(props);

    this.state = { value: false, predicates: [] };
    this.onChange = this.onChange.bind(this);
    this.onPredicateChange = this.onPredicateChange.bind(this);
    this.removePredicate = this.removePredicate.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ predicates: nextProps.predicates });
  }

  onChange(event) {
    this.props.updatePredicates(this.props.attribute, []);
    this.setState({ value: event.target.checked });
  }

  hasPredicates() {
    return this.props.predicates.length > 0;
  }

  removePredicate(key) {
    let newPredicates = update(this.state.predicates, {
      $splice: [[key, 1]]
    });

    this.props.updatePredicates(this.props.attribute, newPredicates);
  }

  onPredicateChange(predicate, key) {
    let newPredicates = update(this.state.predicates, {
      $splice: [[key, 1, predicate]]
    });

    this.props.updatePredicates(this.props.attribute, newPredicates);
  }

  isLastPredicate(index) {
    return this.state.predicates.length === index + 1;
  }

  predicateJoiner(index) {
    if(!this.isLastPredicate(index)) {
      return (<div className='predicate-joiner-wrapper'>
                <span className='predicate-joiner small-uppercase'>and</span>
              </div>);
    }
  }

  predicates() {
    if(this.isChecked()) {
      if(this.hasPredicates()) {
        return (
          <div>
            {this.state.predicates.map((predicate, index) => {
              return (<div key={index}>
                <Predicate
                  index={index}
                  {...predicate} 
                  noNotEqual={this.props.noNotEqual}
                  options={this.props.options} 
                  onPredicateChange={this.onPredicateChange}
                  removePredicate={this.removePredicate} />
                {this.predicateJoiner(index)}
              </div>)
            })}
          </div>
        )
      } else {
        return (
          <div>
            <Predicate 
              key={0} 
              index={0}
              type={this.props.type}
              noNotEqual={this.props.noNotEqual}
              attribute={this.props.attribute}
              options={this.props.options}
              onPredicateChange={this.onPredicateChange}
              removePredicate={this.removePredicate} />
          </div>
        ) 
      }
    }
  }

  isChecked() {
    return this.hasPredicates() || this.state.value;
  }

  render() {
    return (
      <div className='CandidateFilter'>
        <div className='form-check small-uppercase'>
          <label className='form-check-label'>
            <input className='form-check-input' type="checkbox" checked={this.isChecked()} onChange={this.onChange} />
            <i className={`fa fa-fw mr-1 ml-1 ${this.props.icon}`}></i>
            {` ${this.props.name}`}
          </label>
        </div>
        {this.predicates()}
      </div>
    )
  }
}

CandidateFilter.defaultProps = {
  options: [],
  noNotEqual: false
}

export default CandidateFilter
