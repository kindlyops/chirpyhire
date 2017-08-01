import React from 'react'

import { NotificationStack } from 'react-notification'
import { OrderedSet } from 'immutable'

class Notifications extends React.Component {
  constructor() {
    super();
    this.state = {
      notifications: OrderedSet()
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
}

export default Notifications
