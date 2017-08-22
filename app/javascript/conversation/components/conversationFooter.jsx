import React from 'react'

class ConversationFooter extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: ''
    }

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    this.setState({ value: event.target.value })
  }

  conversationId() {
    return this.props.conversation.id;
  }

  partsUrl() {
    return `/conversations/${this.conversationId()}/parts`;
  }

  activeFooter() {
    return (
      <div className="footer">
        <form className="new_message" id="new_message" action={this.partsUrl()} acceptCharset="UTF-8" data-remote="true" method="post">
          <input name="utf8" type="hidden" value="✓" />
          <div className='d-flex align-items-center'>
            <textarea onChange={this.onChange} value={this.state.value} autoFocus="autofocus" autoComplete="off" autoCorrect="off" spellCheck="true" placeholder={`Message ${this.props.contact.handle || 'Someone'}`} rows="1" className="message-input focus" name="message[body]" id="message_body">
            </textarea>
            <span className='ml-2 character-count'>
              {this.state.value.length}
            </span>
          </div>
        </form>
        <div className="spacer"></div>
      </div>
    )
  }

  componentDidMount() {
    $(document).on('keydown', 'form.new_message .message-input', (e) => {
      let combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo) {
        let $form = $('form.new_message');
        let messageBody = $form.find('.message-input');
        e.preventDefault();
        if(messageBody.val().length) {
          $('form.new_message').submit();
          this.setState({ value: '' });
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
    if(this.props.conversation.state !== 'Closed') {
      return this.activeFooter();
    } else {
      return this.disabledFooter();
    }
  }
}

export default ConversationFooter
