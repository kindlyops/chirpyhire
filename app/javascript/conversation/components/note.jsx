import React from 'react'
import moment from 'moment'

class Note extends React.Component {
  timestamp() {
    return moment(this.props.note.created_at).format('h:mm a');
  }

  render() {
    return (
      <div className='message first'>
        <div className="message_gutter">
          <div className="message-icon">
            <div className={`author_image thumb_36 second ${this.props.note.sender_hero_pattern_classes}`}></div>
          </div>
        <a className="timestamp">{this.timestamp()}</a>
        </div>
        <div className="message_content">
          <div className="message_content_header">
            <div className="message_content_header_left">
              <strong className="message-sender">{this.props.note.sender_handle}</strong>
              <a className="timestamp">{this.timestamp()}</a>
            </div>
          </div>
          <span className="message-body">{this.props.note.body}</span>
        </div>
      </div>
    )
  }
}

export default Note
