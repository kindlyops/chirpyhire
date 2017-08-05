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
    return moment(this.props.message.happened_at).format('h:mm a');
  }

  messageIcon() {
    if(this.props.message.sender_url) {
      return (
        <img className='author_image no-repeat thumb_36' src={this.props.message.sender_url}></img>
      );
    } else {
      return (
        <div className={`author_image thumb_36 second ${this.props.message.sender_hero_pattern_classes}`}>
        </div>
      );
    }
  }

  sender() {
    if (this.props.message.direction === 'inbound') {
      return this.props.contact.handle;
    } else {
      return this.props.message.sender_handle;
    }
  }

  render() {
    return (
      <div className={this.classes()}>
        <div className="message_gutter">
          <div className="message-icon">
            {this.messageIcon()}
          </div>
        <a className="timestamp">{this.timestamp()}</a>
        </div>
        <div className="message_content">
          <div className="message_content_header">
            <div className="message_content_header_left">
              <strong className="message-sender">{this.sender()}</strong>
              <a className="timestamp">{this.timestamp()}</a>
            </div>
          </div>
          <span className="message-body">{this.props.message.body}</span>
        </div>
      </div>
    )
  }

  componentDidMount() {
    $('#msgs_scroller_div').scrollTop($('#msgs_div').prop('scrollHeight') + 100);
  }
}

export default Message
