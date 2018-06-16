import React from 'react'
import Textarea from 'react-textarea-autosize'

class ConversationFooter extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: ''
    }

    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);
    this.sendMessage = this.sendMessage.bind(this);
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

  onSubmit(e) {
    e.preventDefault();
    this.sendMessage();
  }

  sendMessage() {
    const params = {
      _method: 'post',
      message: { body: this.state.value }
    };

    const config = {
      url: this.partsUrl(),
      data: params,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }

    $.ajax(config).then(() => {
      this.setState({ value: '' });
    });
  }

  activeFooter() {
    return (
      <div className="footer">
        <form onSubmit={this.onSubmit} className="new_message" id="new_message">
          <div className='d-flex align-items-center'>
            <Textarea onChange={this.onChange} maxLength={480} value={this.state.value} autoFocus="autofocus" autoComplete="off" autoCorrect="off" spellCheck="true" placeholder={`Message ${this.props.contact.handle || 'Someone'}`} rows="1" className="message-input focus" name="message[body]" id="message_body">
            </Textarea>
            <button type="submit" role="button" className='btn btn-primary send-message'>
              Send
            </button>
            <span className='ml-2 small character-count'>
              {this.state.value.length} / {480}
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
          this.sendMessage();
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
