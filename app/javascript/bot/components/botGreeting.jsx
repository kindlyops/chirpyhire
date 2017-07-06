import React from 'react'
import PlainText from '../../plain_text'
import { Collapse } from 'reactstrap'

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
            <span className='bot-card--title'>{this.props.greeting.body}</span>
          </div>
          <a onClick={this.onClick} role="button" className='bot-card--toggle-body'>
            <i className={this.iconClasses()}></i>
          </a>
        </div>
        <Collapse isOpen={this.state.collapse}>
          <div className='card-block'>
            <div className='card-text'>
              <PlainText
                onDocumentChange={this.props.onDocumentChange}
                className='form-control'
                placeholder='Enter a greeting for your candidates...'
                value={this.props.greeting.body}
              />
            </div>
          </div>
        </Collapse>
      </div>
    )
  }
}

BotGreeting.defaultProps = {
  greeting: {
    body: ''
  }
}

export default BotGreeting
