import React from 'react'

class ConversationFooter extends React.Component {
  conversationId() {
    return this.props.inbox_conversation.conversation_id;
  }

  messagesUrl() {
    return `/conversations/${this.conversationId()}/messages`;
  }

  activeFooter() {
    return (
      <div className="footer">
        <form className="new_message" id="new_message" action={this.messagesUrl()} acceptCharset="UTF-8" data-remote="true" method="post">
          <input name="utf8" type="hidden" value="✓" />
          <textarea autoFocus="autofocus" autoComplete="off" autoCorrect="off" spellCheck="true" placeholder={`Message ${this.props.contact.handle || 'Someone'}`} rows="1" className="message-input focus" name="message[body]" id="message_body">
          </textarea>
        </form>
        <div className="spacer"></div>
      </div>
    )
  }

  disabledFooter() {
    return (
      <div className="footer">
        <div className="spacer"></div>
      </div>
    )
  }

  render() {
    if(this.props.inbox_conversation.state !== 'Closed') {
      return this.activeFooter();
    } else {
      return this.disabledFooter();
    }
  }
}

export default ConversationFooter
