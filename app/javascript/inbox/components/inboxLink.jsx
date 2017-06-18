import React from 'react'

class inboxLink extends React.Component {
  constructor(props) {
    super(props);

    this.handleInboxChange = this.handleInboxChange.bind(this);
  }

  handleInboxChange() {
    this.props.handleInboxChange(this.props.form);
  }

  icon() {
    return this.props.icon || 'fa-users';
  }

  render() {
    return (
      <a role="button" className='InboxLink' tabIndex={0} onClick={this.handleInboxChange}>
        <i className={`${this.icon()} fa mr-2`}></i>
        {this.props.name}
      </a>
    )
  }
}

export default inboxLink
