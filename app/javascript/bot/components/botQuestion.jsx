import React from 'react'
import Toggle from 'react-toggle'

class BotQuestion extends React.Component {
  constructor(props) {
    super(props);

    this.toggleQuestion = this.toggleQuestion.bind(this);
  }

  questionId() {
    return this.props.id;
  }

  botId() {
    return this.props.bot_id;
  }

  questionURL() {
    return `/bots/${this.botId()}/questions/${this.questionId()}.json`;
  }

  data() {
    return JSON.stringify({
      question: {
        active: !this.isChecked()
      }
    })
  }

  toggleQuestion() {
    $.ajax({
      url: this.questionURL(),
      type: 'PUT',
      data: this.data(),
      dataType: 'json',
      accepts: 'application/json',
      contentType: 'application/json'
    });
  }

  isChecked() {
    return this.props.active;
  }

  render() {
    return (
      <div className='card'>
        <div className='card-header question--header'>
          <span className='bot-card--label'>Question:</span>
          <span className='bot-card--title'>{this.props.body}</span>
        </div>
        <div className='card-block'>
          <div className='card-text'>
            {`${this.props.answers}`}
          </div>
        </div>
      </div>
    )
  }
}

export default BotQuestion
