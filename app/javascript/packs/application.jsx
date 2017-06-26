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
      organizationSubscription: {},
      clientVersionSubscription: {},
      current_account: { teams: [] },
      current_organization: {},
      client_version: null
    }
  }

  load() {
    $.get(this.currentAccountUrl()).then(current_account => {
      this.setState({current_account: current_account});
    });

    $.get(this.currentOrganizationUrl()).then(current_organization => {
      this.setState({current_organization: current_organization});
      this.connect();
    });

    $.get(this.versionURL()).then(client_version => {
      this.setState({ client_version: client_version });
    });
  }

  currentAccountUrl() {
    return `/current_account`;
  }

  currentOrganizationUrl() {
    return `/current_organization`;
  }

  versionURL() {
    return '/client_version';
  }

  componentDidMount() {
    this.load();
  }

  render() {
    return (
      <Router>
        <div>
          <Switch>
            <Route path="/getting_started" render={props => <GettingStarted {...this.state} {...props} />} />
            <Route path="/candidates" render={props => <Platform {...this.state} {...props} />} />
            <Route path="/inboxes/:inboxId/conversations/:id" render={props => <Inbox {...this.state} {...props} />} />
            <Route path="/inboxes/:inboxId/conversations" render={props => <Inbox {...this.state} {...props} />} />
          </Switch>
        </div>
      </Router>
    )
  }

  connect() {
    let organizationChannel = { 
        channel: 'OrganizationsChannel', 
        id: this.state.current_organization.id 
    };

    let organizationSubscription = window.App.cable.subscriptions.create(
      organizationChannel, this._organizationChannelConfig()
    );

    let clientVersionChannel = { channel: 'ClientVersionsChannel' };

    let clientVersionSubscription = window.App.cable.subscriptions.create(
      clientVersionChannel, this._clientVersionChannelConfig()
    );

    this.setState({ organizationSubscription: organizationSubscription });
  }

  _organizationChannelConfig() {
    return {
      received: this._organizationReceived.bind(this)
    }
  }

  _organizationReceived(organization) {
    this.setState({ current_organization: organization });
  }

  _clientVersionChannelConfig() {
    return {
      received: this._clientVersionReceived.bind(this)
    }
  }

  _clientVersionReceived(client_version) {
    this.setState({ client_version: client_version });
  }

  disconnect() {
    window.App.cable.subscriptions.remove(this.state.organizationSubscription);
    window.App.cable.subscriptions.remove(this.state.clientVersionSubscription); 
  }

  componentWillUnmount() {
    this.disconnect();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('app-container')
  ReactDOM.render(<App/>, node)
})


