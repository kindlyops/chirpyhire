import React from 'react'

class CandidatesMenu extends React.Component {
  constructor(props) {
    super(props);

    this.isDisabled = this.isDisabled.bind(this);
  }

  isDisabled() {
    return this.props.current_organization.subscription.status === 'canceled';
  }

  render() {
    return (<div className='CandidatesMenu ch--main-menu'>
      <div className='ch--main-menu--left'>
        <h2 className='CandidatesCount'>{this.props.total_count} candidates</h2>
      </div>
      <div className='ch--main-menu--right'>
        <button disabled={this.isDisabled()} onClick={this.props.exportCSV} className='btn btn-sm btn-primary export-caregivers' role="button">
          Export
          <i className='fa fa-cloud-download ml-2'></i>
        </button>
      </div>
    </div>)
  }
}

CandidatesMenu.defaultProps = {
  current_organization: {
    subscription: {
      status: ''
    }
  }
}

export default CandidatesMenu
