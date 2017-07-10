import React from 'react'
import Textarea from 'react-textarea-autosize'
import { Collapse, Dropdown, DropdownMenu, DropdownItem } from 'reactstrap'
import BotFollowUp from './botFollowUp'
import { Field, FieldArray } from 'redux-form'

const renderTextarea = ({ input, meta, ...rest }) =>
  <Textarea {...input} {...rest}/>

const renderBotFollowUps = ({ index, formValues, fields, meta: { error, submitFailed } }) => (
  <div>
    {fields.map((follow_up, i) => (<BotFollowUp questionIndex={index} formValues={formValues} follow_up={follow_up} index={i} key={i} />))}
  </div>
)

class BotQuestion extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      collapse: true,
      dropdownOpen: false
    }

    this.toggle = this.toggle.bind(this);
    this.onClick = this.onClick.bind(this);
    this.questionBody = this.questionBody.bind(this);
  }

  toggle() {
    this.setState({ dropdownOpen: !this.state.dropdownOpen });
  }

  onClick() {
    this.setState({ collapse: !this.state.collapse });
  }

  iconClasses() {
    if (this.state.collapse) {
      return 'fa fa-angle-down';
    } else {
      return 'fa fa-angle-up';
    }
  }

  questionBody() {
    const formValues = this.props.formValues || {};
    const bot = formValues.bot || {};
    const questions_attributes = bot.questions_attributes || [];
    const question = questions_attributes[this.props.index] || {};

    return question.body || '';
  }

  render() {
    return (
      <div className='card'>
        <div className='card-header question--header'>
          <div className='bot-card--label-title'>
            <span className='bot-card--label'>Question:</span>
            <span className='bot-card--title'>{this.questionBody()}</span>
          </div>
          <div className='bot-card--actions'>
            <Dropdown isOpen={this.state.dropdownOpen} toggle={this.toggle}>
              <a onClick={this.toggle}
                 data-toggle="dropdown"
                 aria-haspopup="true"
                 aria-expanded={this.state.dropdownOpen} role="button" className='bot-card--settings'>
                ⋯
              </a>
              <DropdownMenu right>
                <DropdownItem role='button'>
                  <i className='fa fa-times mr-2'></i>
                  Remove Question
                </DropdownItem>
              </DropdownMenu>
            </Dropdown>
            <a onClick={this.onClick} role="button" className='bot-card--toggle-body'>
              <i className={this.iconClasses()}></i>
            </a>
          </div>
        </div>
        <Collapse isOpen={this.state.collapse}>
          <div className='card-block'>
            <h5 className='card-title'>What the bot asks:</h5>
            <h6 className="card-subtitle mb-3 text-muted">Ask a meaningful question to interview candidates.</h6>
            <div className='card-text'>
              <Field name={`${this.props.question}.body`} component={renderTextarea} className='form-control' placeholder='Ask a question...' />
            </div>
          </div>
          <hr />
          <div className='card-block'>
            <h5 className='card-title'>Follow ups based on the candidate's answer:</h5>
            <h6 className="card-subtitle mb-3 text-muted">Make your conversations sincere. Configure potential follow ups below.</h6>
            <div className='card-text'>
              <div>
                <FieldArray name={`${this.props.question}.follow_ups_attributes`} props={this.props} component={renderBotFollowUps} />
              </div>
              <button role="button" className='btn btn-default'>
                <i className='fa fa-plus mr-2'></i>
                New Follow Up
              </button>
            </div>
          </div>
        </Collapse>
      </div>
    )
  }
}

export default BotQuestion
