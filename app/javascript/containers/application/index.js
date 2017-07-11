import React from 'react'
import { Route, Switch } from 'react-router'

import Engage from '../engage'
import Platform from '../platform'
import Inbox from '../inbox'

class Application extends React.Component {
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

  render() {
    return (<Switch>
              <Route path="/engage" render={props => <Engage {...this.state} {...props} />} />
              <Route path="/candidates" render={props => <Platform {...this.state} {...props} />} />
              <Route path="/inboxes/:inboxId/conversations" render={props => <Inbox {...this.state} {...props} />} />
              <Route path="/inboxes/:inboxId/conversations/:id" render={props => <Inbox {...this.state} {...props} />} />
            </Switch>);
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

export default Application;
