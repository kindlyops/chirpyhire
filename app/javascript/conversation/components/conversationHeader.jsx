import React from 'react'

class ConversationHeader extends React.Component {
  conversationUrl() {
    return `/inboxes/${this.inboxId()}/conversations/${this.conversationId()}`;
  }

  inboxId() {
    return this.props.inbox_conversation.inbox_id;
  }

  conversationId() {
    return this.props.inbox_conversation.conversation_id;
  }

  closedButton() {
    if(this.props.inbox_conversation.state !== 'Closed') {
      return (
        <form className='edit_conversation' id={`edit_conversation_${this.conversationId()}`} action={this.conversationUrl()} method="post" data-remote={true}>
          <input type="hidden" name="_method" value="put" />
          <input type="hidden" name="conversation[state]" value="Closed" />
          <button type="submit" className='btn btn-default'>
            <i className='fa fa-check mr-2'></i>
            Close
          </button>
        </form>
      )
    }
  }

  render() {
    return (
      <header className='chat-header'>
        <div className='channel-header'>
          <div className='messages-header'>
            <div className='channel-title d-flex justify-content-between align-items-center'>
              <div className='name-and-phone-number'>
                <div className='channel-name-container'>
                  <div className='channel-name'>
                    <span>{this.props.contact.handle}</span>
                  </div>
                </div>
                <div className='channel-header-info'>
                  <div className='channel-header-info-item'>
                    {this.props.contact.phone_number}
                  </div>
                </div>
              </div>
              <div className='channel-title-info mr-3'>
                {this.closedButton()}
              </div>
            </div>
          </div>
        </div>
      </header>
    )
  }
}

export default ConversationHeader
