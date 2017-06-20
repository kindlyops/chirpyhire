/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import 'react-select/dist/react-select.css'
import 'react-virtualized/styles.css'

import React from 'react'
import ReactDOM from 'react-dom'
import {
  BrowserRouter as Router,
  Route,
  Switch
} from 'react-router-dom'

import Inbox from 'inbox'
import Platform from 'platform'
import GettingStarted from 'getting_started'

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      current_account: { teams: [] }
    }
  }

  load() {
    $.get(this.currentAccountUrl()).then(current_account => {
      this.setState({current_account: current_account})
    })
  }

  currentAccountUrl() {
    return `/current_account`;
  }

  componentDidMount() {
    this.load();
  }

  render() {
    return (
      <Router>
        <div>
          <Switch>
            <Route path="/getting_started" render={props => <GettingStarted current_account={this.state.current_account} {...props} />} />
            <Route path="/candidates" render={props => <Platform current_account={this.state.current_account} {...props} />} />
            <Route path="/inboxes/:inboxId/conversations/:id" render={props => <Inbox current_account={this.state.current_account} {...props} />} />
            <Route path="/inboxes/:inboxId/conversations" render={props => <Inbox current_account={this.state.current_account} {...props} />} />
          </Switch>
        </div>
      </Router>
    )
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('app-container')
  ReactDOM.render(<App/>, node)
})


