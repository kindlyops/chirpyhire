import React from 'react'
import Textarea from 'react-textarea-autosize'
import { Collapse, Dropdown, DropdownMenu, DropdownItem } from 'reactstrap'
import { Field } from 'redux-form'
import Select from 'react-select'

const renderTextarea = ({ input, meta, ...rest }) =>
  <Textarea {...input} {...rest}/>

const getTags = (input, callback) => {
  return $.get('/tags').then((response) => {
    return callback(null, { options: response })
  });
}

const renderSelect = ({ input, meta, ...rest }) => (
  <Select.Async 
    {...input}
    {...rest}
    valueKey='id'
    labelKey='name'
    multi={true}
    loadOptions={getTags} />
)

class BotGoal extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      collapse: true,
      dropdownOpen: false
    }

    this.toggle = this.toggle.bind(this);
    this.onClick = this.onClick.bind(this);
    this.goal = this.goal.bind(this);
    this.goalBody = this.goalBody.bind(this);
    this.onRemoveClick = this.onRemoveClick.bind(this);
    this.isMarkedForDeletion = this.isMarkedForDeletion.bind(this);
  }

  isMarkedForDeletion() {
    return !!this.goal()._destroy;
  }

  onRemoveClick() {
    this.props.change(`${this.props.goal}._destroy`, true);
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

  goal() {
    const formValues = this.props.formValues || {};
    const bot = formValues.bot || {};
    const goals_attributes = bot.goals_attributes || [];
    return goals_attributes[this.props.index] || {};
  }

  goalBody() {
    return this.goal().body || '';
  }

  render() {
    return (
      <div className='card' hidden={this.isMarkedForDeletion()}>
        <div className='card-header goal--header'>
          <div className='bot-card--label-title'>
            <span className='bot-card--label'>Goal:</span>
            <span className='bot-card--title'>{this.goalBody()}</span>
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
                <DropdownItem role='button' onClick={this.onRemoveClick}>
                  <Field name={`${this.props.goal}._destroy`} component="input" type="checkbox" hidden={true} />
                  <i className='fa fa-times mr-2'></i>
                  Remove Goal
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
            <h5 className='card-title'>Tags:</h5>
            <h6 className="card-subtitle mb-3 text-muted">Add one or more useful tags to apply to candidates who hit this goal.</h6>
            <Field name={`${this.props.goal}.tags_attributes`} component={renderSelect} />
          </div>
          <hr />
          <div className='card-block'>
            <h5 className='card-title'>Send Message:</h5>
            <h6 className="card-subtitle mb-3 text-muted">Create a meaningful message to end the bot conversation for candidates who hit this goal.</h6>
            <div className='card-text'>
              <Field name={`${this.props.goal}.body`} component={renderTextarea} className='form-control' placeholder='Write a meaningful message...' />
            </div>
          </div>
        </Collapse>
      </div>
    )
  }
}

export default BotGoal
