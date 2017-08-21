import React from 'react'

class TextCandidateFilter extends React.Component {
  constructor(props) {
    super(props);
  }

  predicate() {
    if(this.isChecked()) {
      return (
        <div className='predicate'>
          <div className='predicate-inner'>
            <input 
              className='Text-input' 
              type="text" 
              name={this.name()} 
              value={this.value()} 
              onChange={this.props.handleTextChange}
              placeholder='Search' />
          </div>
        </div>
      )
    }
  }

  value() {
    if(!this.props.form.q) return '';

    return this.props.form.q[this.key()] || '';
  }

  key() {
    return `${this.name()}_cont`;
  }

  isChecked() {
    let query = this.props.form.q;

    return query && query[this.key()] || this.props.checked;
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

export default TextCandidateFilter
