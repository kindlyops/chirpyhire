import React from 'react'
import { Link } from 'react-router-dom'

class ConversationHeader extends React.Component {
  constructor(props) {
    super(props);

    this.closeOptions = this.closeOptions.bind(this);
  }

  conversationUrl() {
    return `/inboxes/${this.inboxId()}/conversations/${this.conversationId()}`;
  }

  inboxId() {
    return this.props.conversation.inbox_id;
  }

  conversationId() {
    return this.props.conversation.id;
  }

  existingOpenConversationId() {
    return this.props.contact.existing_open_conversation_id;
  }

  existingOpenConversationUrl() {
    return `/inboxes/${this.inboxId()}/conversations/${this.existingOpenConversationId()}`;
  }

  otherExistingConversation() {
    let existingId = this.existingOpenConversationId();
    return !!existingId && (existingId !== this.conversationId());
  }

  actionButton() {
    if(this.props.conversation.state === 'Open') {
      return this.closeButton();
    } else if (this.otherExistingConversation()) {
      return this.messageButton();
    } else if (this.props.conversation.reopenable) {
      return this.reopenButton();
    } else {
      return this.disabledClosedButton();
    }
  }

  messageButton() {
    return (
      <Link to={this.existingOpenConversationUrl()} className='btn btn-primary'>
        Message
        <i className='fa fa-comment ml-2'></i>
      </Link>
    )
  }

  closeOptions() {
    return (<div className="dropdown-menu dropdown-menu-right" aria-labelledby="closeConversationButton">
     {this.props.contact.contact_stages.map(stage =>
        <form key={stage.id} className='edit_conversation' id={`edit_conversation_${this.conversationId()}`} action={this.conversationUrl()} method="post" data-remote={true}>
          <input type="hidden" name="_method" value="put" />
          <input type="hidden" name="conversation[state]" value="Closed" />
          <input type="hidden" name="conversation[contact_attributes][contact_stage_id]" value={stage.id} />
          <input type="hidden" name="conversation[contact_attributes][id]" value={this.props.contact.id} />
          <button type="submit" className='dropdown-item' role="button">
            Close + Mark {stage.name}
          </button>
        </form>
      )}
    </div>)
  }

  closeButton() {
    return (
      <div className="dropdown">
        <button type="button" role="button" className='btn btn-default dropdown-toggle' id="closeConversationButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i className='fa fa-check mr-2'></i>
          <span className='mr-1'>Close</span>
        </button>
        {this.closeOptions()}
      </div>
    )
  }

  reopenButton() {
    return (
      <form className='edit_conversation' id={`edit_conversation_${this.conversationId()}`} action={this.conversationUrl()} method="post" data-remote={true}>
        <input type="hidden" name="_method" value="put" />
        <input type="hidden" name="conversation[state]" value="Open" />
        <button type="submit" className='btn btn-default'>
          <i className='fa fa-inbox mr-2'></i>
          Reopen
        </button>
      </form>
    )
  }

  disabledClosedButton() {
    return (
      <a href="#" disabled={true} className='btn btn-default disabled'>
        <i className='fa fa-ban mr-2'></i>
        Closed
      </a>
    )
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
                {this.actionButton()}
              </div>
            </div>
          </div>
        </div>
      </header>
    )
  }
}

ConversationHeader.defaultProps = {
  contact: {
    id: '',
    contact_stages: []
  }
}

export default ConversationHeader
