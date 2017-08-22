import React from 'react'
import Predicate from './predicate'

class CandidateFilter extends React.Component {
  constructor(props) {
    super(props);

    this.state = { value: false };
    this.onChange = this.onChange.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if(nextProps.predicates.length > 0) {
      this.setState({ value: true });
    }
  }

  onChange() {
    this.props.updatePredicates(this.props.attribute, []);
    this.setState({ value: !this.state.value });
  }

  hasPredicates() {
    return this.props.predicates.length > 0;
  }

  predicates() {
    if(this.isChecked()) {
      return (
        <div>
          {this.props.predicates.map((predicate, index) =>
            <Predicate 
              key={index} 
              {...predicate} 
              options={this.props.options} 
              onChange={this.props.onPredicateChange} /> 
          )}
        </div>
      )
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
  options: []
}

export default CandidateFilter
