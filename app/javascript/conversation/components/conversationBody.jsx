import React from 'react'
import ConversationFooter from './conversationFooter'
import ConversationEndCap from './conversationEndCap'
import ConversationDay from './conversationDay'
import moment from 'moment'

class ConversationBody extends React.Component {
  days() {
    return R.groupWith(this._sameDay, this.props.messages);
  }

  _sameDay(first, second) {
    let firstMoment = moment(first.external_created_at);
    let secondMoment = moment(second.external_created_at);

    return firstMoment.isSame(secondMoment, 'day');
  }

  render() {
    return (
        <div className='client_body'>
          <div className='client_messages'>
            <ConversationFooter contact={this.props.contact} />
            <div id='messages_container'>
              <div id='msgs_scroller_div' className='message_pane_scroller'>
                <ConversationEndCap contact={this.props.contact} />
                <div className="msgs_holder" id="msgs_div">
                  {this.days().map((day) =>
                    <ConversationDay key={day[0].external_created_at} messages={day} day={day[0].external_created_at} contact={this.props.contact} />
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>

    )
  }
}

export default ConversationBody
