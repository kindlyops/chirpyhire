import React from 'react'

import { NotificationStack } from 'react-notification'
import { OrderedSet } from 'immutable'

class Notifications extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      notifications: OrderedSet(),
      subscription: {}
    };
  }

  addNotification(notification) {
    return this.setState({
      notifications: this.state.notifications.add({
        message: notification.message,
        key: notification.key,
        dismissAfter: 4000,
        onClick: (notification, deactivate) => {
          deactivate();
          this.removeNotification(notification.key);
        },
      })
    });
  }

  removeNotification(count) {
    this.setState({
      notifications: this.state.notifications.filter(n => n.key !== count)
    })
  }

  render() {
    return (
      <NotificationStack
        notifications={this.state.notifications.toArray()}
        onDismiss={notification => this.setState({
          notifications: this.state.notifications.delete(notification)
        })}
      />
    );
  }

  componentDidMount() {
    let channel = { channel: 'NotificationsChannel' };
    let subscription = window.App.cable.subscriptions.create(
      channel, this.config()
    );

    this.setState({ subscription: subscription });
  }

  config() {
    return {
      received: this.received.bind(this)
    }
  }

  received(notification) {
    this.addNotification(notification);
  }

  componentWillUnmount() {
    window.App.cable.subscriptions.remove(this.state.subscription);
  }
}

export default Notifications
