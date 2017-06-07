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

  componentDidMount() {
    $(document).on('keydown', 'form.new_message .message-input', function(e) {
      let combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo) {
        let $form = $('form.new_message');
        let messageBody = $form.find('.message-input');
        e.preventDefault();
        if(messageBody.val().length) {
          $('form.new_message').submit();
          messageBody.val('');
        }
      }
    });
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
