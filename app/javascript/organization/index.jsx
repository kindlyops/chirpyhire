import React from 'react'
import Account from './account'

class Organization extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      subscription: {},
      model: {}
    }
  }

  render() {
    return (
      <Account current_organization={this.state.model} />
    )
  }

  componentDidMount() {
    $.get(this.url()).then(model => {
      this.setState({ model });
      this.connect();
    });
  }

  componentWillUnmount() {
    window.App.cable.subscriptions.remove(this.state.subscription);
  }
 
  connect() {
    let subscription = window.App.cable.subscriptions.create(
      this.channel(), this.config()
    );

    this.setState({ subscription });
  }

  url() {
    return `/current_organization`;
  }

  channel() {
    return {
      channel: 'OrganizationsChannel', 
      id: this.state.model.id 
    }
  }

  config() {
    return {
      received: this.received.bind(this)
    }
  }

  received(model) {
    this.setState({ model: model });
  }
}

export default Organization
