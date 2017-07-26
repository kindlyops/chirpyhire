import React from 'react'
import Message from './message'
import Moment from 'moment'
import { extendMoment } from 'moment-range';
const moment = extendMoment(Moment);

class ConversationDay extends React.Component {
  constructor(props) {
    super(props)

    this.byThought = this.byThought.bind(this);
  }

  dayLabel() {
    return moment(this.props.day).format('MMMM Do');
  }

  thoughts() {
    return R.groupWith(this.byThought, this.props.messages);
  }

  byThought(first, second) {
    return this.isSameAuthor(first, second) && this.isWithinFiveMinutes(first, second);
  }

  isSameAuthor(first, second) {
    return first.sender_id === second.sender_id;
  }

  isWithinFiveMinutes(first, second) {
    let firstMoment = moment(first.external_created_at);
    let secondMoment = moment(second.external_created_at);
    let difference = moment.range(firstMoment, secondMoment).diff('minutes');

    return Math.abs(difference) < 5;
  }

  orderedMessages(messages) {
    return messages.sort((first, second) => (
      moment(first.external_created_at) - moment(second.external_created_at)
    ))
  }

  render() {
    return (
      <div className="day_container">
        <div className="day_divider">
          <i className="copy_only"><br />\-----</i>
          <div className="day_divider_label">{this.dayLabel()}</div>
          <i className="copy_only">-----</i>
        </div>
        <div className="day_msgs">
        {this.thoughts().map((messages) =>
          this.orderedMessages(messages).map((message, index) =>
              <Message thoughtId={index} key={message.id} message={message} contact={this.props.contact} />
            )
          )
        }
        </div>
      </div>
    )
  }
}

export default ConversationDay
