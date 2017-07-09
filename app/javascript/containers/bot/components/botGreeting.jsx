import React from 'react'
import Textarea from 'react-textarea-autosize'
import { Collapse } from 'reactstrap'
import { Field } from 'redux-form'

class BotGreeting extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      collapse: true
    }

    this.onClick = this.onClick.bind(this);
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
        <div className='card-header greeting--header'>
          <div className='bot-card--label-title'>
            <span className='bot-card--label'>Greeting:</span>
            <span className='bot-card--title'>{this.props.body}</span>
          </div>
          <a onClick={this.onClick} role="button" className='bot-card--toggle-body'>
            <i className={this.iconClasses()}></i>
          </a>
        </div>
        <Collapse isOpen={this.state.collapse}>
          <div className='card-block'>
            <div className='card-text'>
              <h5 className='card-title'>Create a friendly greeting:</h5>
              <h6 className="card-subtitle mb-3 text-muted">Make a great first impression with every candidate.</h6>
              <Field name="greeting.body" component="textarea" className='form-control' placeholder='Write a friendly greeting...' />
            </div>
          </div>
        </Collapse>
      </div>
    )
  }
}

BotGreeting.defaultProps = {
  body: ''
}

export default BotGreeting
