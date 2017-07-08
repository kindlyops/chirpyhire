import React from 'react'
import Textarea from 'react-textarea-autosize'
import { Collapse, Dropdown, DropdownMenu, DropdownItem } from 'reactstrap'

class BotGoal extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      collapse: true,
      dropdownOpen: false
    }

    this.toggle = this.toggle.bind(this);
    this.onClick = this.onClick.bind(this);
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

  render() {
    return (
      <div className='card'>
        <div className='card-header goal--header'>
          <div className='bot-card--label-title'>
            <span className='bot-card--label'>Goal:</span>
            <span className='bot-card--title'>{this.props.body}</span>
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
            <h5 className='card-title'>Send Message:</h5>
            <h6 className="card-subtitle mb-3 text-muted">Create a meaningful message to end the bot conversation for candidates who hit this goal.</h6>
            <div className='card-text'>
              <Textarea
                onChange={this.props.onChange}
                name="bot[goals_attributes][][body]"
                id={this.props.id}
                className='form-control'
                placeholder='Write a meaningful message...'
                value={this.props.body}
              />
            </div>
          </div>
        </Collapse>
      </div>
    )
  }
}

export default BotGoal
