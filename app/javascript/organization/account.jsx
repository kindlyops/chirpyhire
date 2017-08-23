import React from 'react'
import { Route } from 'react-router-dom'
import PropTypes from 'prop-types'

import Candidates from '../candidates'
import Inboxes from '../inboxes'

class Account extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      model: { teams: [] }
    }
  }

  getChildContext() {
    return {
      current_account: this.state.model,
      current_organization: this.props.current_organization
    }
  }

  render() {
    return (
      <div>
        <Route path="/candidates" component={Candidates} />
        <Route path="/inboxes" component={Inboxes} />
      </div>
    )
  }

  // <Route path="/inboxes" component={Inboxes} />
  // <Route path="/inboxes/:inboxId" component={Inbox} />
  // <Route path="/inboxes/:inboxId/conversations" component={Conversations} />
  // <Route path="/inboxes/:inboxId/conversations/:id" component={Conversation} />

  url() {
    return `/current_account`;
  }

  componentDidMount() {
    $.get(this.url()).then(model => {
      this.setState({ model });
    });
  }
}

Account.childContextTypes = {
  current_account: PropTypes.object,
  current_organization: PropTypes.object
}

export default Account
