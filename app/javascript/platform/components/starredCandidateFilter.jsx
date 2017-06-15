import React from 'react'
import Select from 'react-select'

class StarredCandidateFilter extends React.Component {

  name() {
    return this.props.attribute.toLowerCase();
  }

  isChecked() {
    return !!this.props.form.starred;
  }

  render() {
    return (
      <div className='CandidateFilter CandidateFilter--starred'>
        <div className='form-check small-caps'>
          <label className='form-check-label'>
            <input className='form-check-input' 
              onChange={this.props.handleStarChange} 
              name={this.name()} 
              checked={this.isChecked()} 
              type="checkbox" 
              value="" />
            <i className={`fa fa-fw mr-1 ml-1 ${this.props.icon}`}></i>
            {` ${this.props.attribute}`}
          </label>
        </div>
      </div>
    )
  }
}

export default StarredCandidateFilter
