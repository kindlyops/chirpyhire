import React from 'react'
import CreateSegmentModal from './createSegmentModal'

class CandidateFiltersActions extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      modal: false
    };
    
    this.toggleModal = this.toggleModal.bind(this);
  }

  toggleModal() {
    this.setState({
      modal: !this.state.modal
    });
  }

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
          <CreateSegmentModal modal={this.state.modal} />
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
