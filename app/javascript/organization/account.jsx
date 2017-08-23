import React from 'react'
import { Route, Switch } from 'react-router-dom'
import PropTypes from 'prop-types'

import Candidates from '../candidates'
import Inbox from '../inbox'

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
        <Switch>
          <Route path="/candidates" component={Candidates} />
          <Route path="/inboxes/:inboxId/conversations/:id" component={Inbox} />
          <Route path="/inboxes/:inboxId/conversations" component={Inbox} />
        </Switch>
      </div>
    )
  }

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
