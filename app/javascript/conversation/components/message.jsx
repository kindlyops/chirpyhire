import React from 'react'
import moment from 'moment'

class Message extends React.Component {
  classes() {
    if (this.props.thoughtId === 0) {
      return 'message first';
    } else {
      return 'message';
    }
  }

  timestamp() {
    return moment(this.props.message.external_created_at).format('h:mm a');
  }

  render() {
    return (
      <div className={this.classes()}>
        <div className="message_gutter">
          <div className="message-icon">
            <div className={`author_image thumb_36 second ${this.props.message.sender_hero_pattern_classes}`}></div>
          </div>
        <a className="timestamp">{this.timestamp()}</a>
        </div>
        <div className="message_content">
          <div className="message_content_header">
            <div className="message_content_header_left">
              <strong className="message-sender">{this.props.message.sender_handle}</strong>
              <a className="timestamp">{this.timestamp()}</a>
            </div>
          </div>
          <span className="message-body">{this.props.message.body}</span>
        </div>
      </div>
    )
  }
}

export default Message
