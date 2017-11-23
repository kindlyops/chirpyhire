import React from 'react'
import { Modal, Button, ModalFooter, ModalBody, Tooltip } from 'reactstrap'
import PropTypes from 'prop-types'

class CandidatesMenu extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      modal: false,
      tooltipOpen: false
    }
    this.toggle = this.toggle.bind(this);
    this.toolTipToggle = this.toolTipToggle.bind(this);
    this.isDisabled = this.isDisabled.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
  }

  toggle() {
    this.setState({
      modal: !this.state.modal
    });
  }

  toolTipToggle() {
    this.setState({
      tooltipOpen: !this.state.tooltipOpen
    });
  }

  isDisabled() {
    const organization = this.context.current_organization || {};
    const subscription = organization.subscription || {};

    return subscription.status === 'canceled';
  }

  isMessageDisabled() {
    let isNone = this.props.total_count === 0;
    let isAll = this.props.total_count === this.props.contact_total_count;
    return isNone || (isAll && !this.isSelected()) || this.isDisabled();
  }

  inflect(count, word) {
    if (count === 1) {
      return word;
    } else {
      return `${word}s`;
    }
  }

  selected() {
    if (this.isSelected()) {
      return _.filter(this.props.candidates, { 'selected': true });
    } else {
      return this.props.candidates;
    }
  }

  count() {
    if(this.isSelected()) {
      return (
        <h2 className='CandidatesCount'>
          {this.selected().length}{' '}
          {this.inflect(this.selected().length, 'candidate')}
          {' '}selected{' '}<span className='small text-muted'>of{' '}
          {this.props.contact_total_count}</span>
        </h2>
      )
    } else {
      return (
        <h2 className='CandidatesCount'>
          {this.props.total_count}{' '}{this.inflect(this.props.total_count, 'candidate')}{' '}
          <span className='small text-muted'>of {this.props.contact_total_count}</span>
        </h2>
      )
    }
  }
 
  render() {
    return (<div className='CandidatesMenu ch--main-menu'>
      <div className='ch--main-menu--left'>
        {this.count()}
      </div>
      <div className='ch--main-menu--right'>
        <button className='btn btn-sm btn-default mr-2' disabled={this.isMessageDisabled()} onClick={this.toggle} role='button'>
          Message
          <i className='fa fa-paper-plane ml-2'></i>
        </button>
        <i id="messageInfo" className='fa fa-question-circle mr-2'></i>
        <Tooltip placement="bottom" target="messageInfo" isOpen={this.state.tooltipOpen} toggle={this.toolTipToggle}>
          To send a targeted message to a group of candidates, make sure to filter your candidates first.
        </Tooltip>
        <a className='btn btn-sm btn-success mr-2' href='/import/csv/new' role="button">
          Import
          <i className='fa fa-cloud-upload ml-2'></i>
        </a>
        <button disabled={this.isDisabled()} onClick={this.props.exportCSV} className='btn btn-sm btn-primary export-candidates mr-2' role="button">
          Export
          <i className='fa fa-cloud-download ml-2'></i>
        </button>
        <a className='btn btn-sm btn-default' href='/candidates/new' role="button">
          Add
          <i className='fa fa-user-plus ml-2'></i>
        </a>
      </div>
      {this.createMessageModal()}
    </div>)
  }

  initials(candidate) {
    let names = candidate.name.split(' ');
    let last = names.length - 1;
    names = [names[0], names[last]];
    return names.map(function (s) { return s.charAt(0).toUpperCase(); }).join('');
  }

  createMessageModal() {
    return (
      <Modal className={'modal--manual-messages'} isOpen={this.state.modal} toggle={this.toggle} backdrop={true}
      >
        <form onSubmit={this.onSubmit}>
          <div className='modal-header'>
            <div className='top-header'>
              <h5 className="modal-title" id="messageModal">New Message</h5>
              <button type="button" className="close" onClick={this.toggle} aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div className="manual-message-header">
              {this.selected().slice(0, 4).map(candidate => 
                <span className="recipient" key={candidate.id}>
                  <span className='candidateAvatar mr-2'>
                    <span className={`candidateAvatarImage ${candidate.hero_pattern_classes}`}>
                      {this.initials(candidate)}
                    </span>
                  </span>
                  {candidate.name}
                </span> 
              )}
              {this.tail()}
            </div>
          </div>
          <ModalBody>
              <div className="form-group">
                <label htmlFor="manual_message[title]">Title</label>
                <input type="text" required={true} ref={(title) => this._title = title} className="form-control" id="manual_message[title]" aria-describedby="manualMessageTitleHelp" placeholder="Add a title" />
                <small id="manualMessageTitleHelp" className="form-text text-muted">Use a title to track engagement of your messages. Reports coming soon.</small>
              </div>
              <div className="form-group">
                <label htmlFor="manual_message[body]">Message</label>
                <textarea required={true} ref={(body) => this._body = body} rows={3} className="form-control" id="manual_message[body]" aria-describedby="manualMessageBodyHelp" placeholder="Write a personal message" />
                <small id="manualMessageBodyHelp" className="form-text text-muted">Each message will be sent separately. Recipients will not see each other.</small>
              </div>
          </ModalBody>
          <ModalFooter>
            <Button color="secondary" role="button" onClick={this.toggle}>Cancel</Button>{' '}
            <Button color="primary" role="button" type="submit">Send</Button>
          </ModalFooter>
          </form>
      </Modal>
    )
  }

  tail() {
    if(this.props.total_count <= 4 || this.selected().length <= 4) {
      return '';
    } else {
      if (this.isSelected()) {
        let difference = this.selected().length - 4;
        return <span className='recipient'>{` and ${difference} others`}</span>;
      } else {
        let difference = this.props.total_count - 4;
        return <span className='recipient'>{` and ${difference} others`}</span>;
      }
    }
  }

  isSelected() {
    return _.some(this.props.candidates, { 'selected': true });
  }

  onSubmit(e) {
    e.preventDefault();
    var form = this.props.form;

    if (this.isSelected()) {
      if(!form.predicates) {
        form.predicates = [];
      }
      form.predicates.push({
        type: 'integer', attribute: 'id',
        value: _.map(this.selected(), 'id'), comparison: 'in'
      })
    }

    const params = {
      _method: 'post',
      manual_message: {
        title: $(this._title).val(),
        body: $(this._body).val(),
        audience: form
      }
    };

    const config = {
      url: '/engage/manual/messages',
      data: JSON.stringify(params),
      type: 'POST',
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json'
    }

    $.ajax(config);
    this.setState({ modal: false });
    if (!this.isSelected()) {
      setTimeout(this.props.searchCandidates, 1500);
    }
  }
}


CandidatesMenu.contextTypes = {
  current_organization: PropTypes.object
}

export default CandidatesMenu
