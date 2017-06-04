import React from 'react'

class ConversationFooter extends React.Component {
  render() {
    return (
      <div className="footer">
        <form className="new_message" id="new_message" action={`/contacts/${this.props.contact.id}/messages`} acceptCharset="UTF-8" data-remote="true" method="post">
          <input name="utf8" type="hidden" value="✓" />
          <textarea autoFocus="autofocus" autoComplete="off" autoCorrect="off" spellCheck="true" placeholder={`Message ${this.props.contact.handle || 'Someone'}`} rows="1" className="message-input focus" name="message[body]" id="message_body">
          </textarea>
        </form>
        <div className="spacer"></div>
      </div>
    )
  }
}

export default ConversationFooter
