import React from 'react'
import { Modal, Button, ModalFooter, ModalBody } from 'reactstrap'

class CandidateFiltersActions extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      modal: false,
      name: ''
    };
    
    this.toggle = this.toggle.bind(this);
    this.onChange = this.onChange.bind(this);
    this.createSegment = this.createSegment.bind(this);
  }

  toggle() {
    this.setState({
      modal: !this.state.modal
    });
  }

  onChange(e) {
    this.setState({
      name: e.target.value
    })
  }

  params() {
    return {
      segment: {
        name: this.state.name, form: this.props.form
      }
    }
  }

  createSegment() {
    $.post('/segments', this.params()).then(segment => {
      this.props.handleSegment(segment);
      this.setState({ name: '' });
      this.toggle();
    })
  }

  hasActiveForm() {
    return this.props.form.q;
  }

  createSegmentModal() {
    return (
      <Modal className={'modal--segments'} isOpen={this.state.modal} toggle={this.toggle} backdrop={true}
      >
        <div className='modal-header'>
          <h5 className="modal-title" id="segmentModal">Create segment</h5>
          <button type="button" className="close" onClick={this.toggle} aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <ModalBody>
          <div className="form-group">
            <label htmlFor="segment_name">Name</label>
            <input type="email" onChange={this.onChange} value={this.state.name} className="form-control" id="segment_name" aria-describedby="segmentNameHelp" placeholder="Enter new segment name" />
            <small id="segmentNameHelp" className="form-text text-muted">New segments created are visible to you, but hidden for your team members.</small>
          </div>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" role="button" onClick={this.toggle}>Cancel</Button>{' '}
          <Button color="primary" role="button" onClick={this.createSegment}>Create segment</Button>
        </ModalFooter>
      </Modal>
    )
  }

  actions() {
    if(this.hasActiveForm()) {
      return (
        <div className='ch--vertical-navigation-actions'>
          <button onClick={this.toggle} role="button" className='btn btn-block btn-primary'>
            <i className='fa fa-pie-chart mr-2'></i>
            <span>Create Segment</span>
          </button>
          {this.createSegmentModal()}
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
