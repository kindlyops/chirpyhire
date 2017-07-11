import React from 'react'
import { Field } from 'redux-form'

class BotFollowUp extends React.Component {
  constructor(props) {
    super(props);

    this.tags = this.tags.bind(this);
    this.followUp = this.followUp.bind(this);
    this.action = this.action.bind(this);
    this.response = this.response.bind(this);
    this.onRemoveClick = this.onRemoveClick.bind(this);
    this.isMarkedForDeletion = this.isMarkedForDeletion.bind(this);
  }

  isMarkedForDeletion() {
    return !!this.followUp()._destroy;
  }

  onRemoveClick() {
    this.props.change(`${this.props.follow_up}._destroy`, true);
  }

  actionClasses() {
    switch(this.action()) {
      case 'next_question':
        return 'FollowUp--action badge badge-next-question';
        break;
      case 'question':
        return 'FollowUp--action badge badge-question';
        break;
      case 'goal':
        return 'FollowUp--action badge badge-goal';
        break;
    }
  }

  tags() {
    return this.followUp().tags_attributes || [];
  }

  followUp() {
    const formValues = this.props.formValues || {};
    const bot = formValues.bot || {};
    const questions_attributes = bot.questions_attributes || [];
    const question = questions_attributes[this.props.questionIndex] || {};
    const follow_ups_attributes = question.follow_ups_attributes || [];
    return follow_ups_attributes[this.props.index] || {};
  }

  humanizedAction() {
    return this.followUp().humanized_action || '';
  }

  action() {
    return this.followUp().action || '';
  }

  response() {
    return this.followUp().response || '';
  }

  render() {
    return(<div className='FollowUp mb-2' hidden={this.isMarkedForDeletion()}>
            <Field name={`${this.props.follow_up}.body`} component="input" className='form-control' placeholder='Add a follow up...' />
            <div className='FollowUp--footer'>
              <div className='FollowUp--details'>
                <span className='FollowUp--response badge badge-default'>
                  {this.response()}
                </span>
                <span className={this.actionClasses()}>
                  {this.humanizedAction()}
                </span>
                <span className='FollowUp--tags'>
                  {this.tags().map(tag =>
                    <span key={tag.id} className='ch-tag'>
                      <i className='fa fa-tag mr-2'></i>
                      {tag.name}
                    </span>
                  )}
                </span>
              </div>
              <div className='FollowUp--actions'>
                <a role="button">
                  <i className='fa fa-sliders'></i>
                </a>
                <a role="button" onClick={this.onRemoveClick}>
                  <Field name={`${this.props.follow_up}._destroy`} component="input" type="checkbox" hidden={true} />
                  <i className='fa fa-trash-o'></i>
                </a>
              </div>
            </div>
          </div>)
  }
}

export default BotFollowUp
