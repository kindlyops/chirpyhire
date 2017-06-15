import React from 'react'


class CandidateFiltersActions extends React.Component {
  hasActiveForm() {
    return !R.equals(["page"], Object.keys(this.props.form));
  }

  actions() {
    if(this.hasActiveForm()) {
      return (
        <div className='CandidateFiltersActions'>
          <button className='btn btn-block btn-primary'>
            <i className='fa fa-pie-chart mr-2'></i>
            <span>Create Segment</span>
          </button>
        </div>
      )
    } else {
      return null;
    }
  }

  render() {
    return this.actions();
  }
}

export default CandidateFiltersActions
