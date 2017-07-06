import React from 'react'
import Textarea from 'react-textarea-autosize'
import { Collapse } from 'reactstrap'

class BotQuestion extends React.Component {
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
        <div className='card-header question--header'>
          <div className='bot-card--label-title'>
            <span className='bot-card--label'>Question:</span>
            <span className='bot-card--title'>{this.props.body}</span>
          </div>
          <a onClick={this.onClick} role="button" className='bot-card--toggle-body'>
            <i className={this.iconClasses()}></i>
          </a>
        </div>
        <Collapse isOpen={this.state.collapse}>
          <div className='card-block'>
            <h5 className='card-title'>What the bot asks:</h5>
            <div className='card-text'>
              <Textarea
                onChange={this.props.onChange}
                name="bot[questions_attributes][][body]"
                id={this.props.id}
                className='form-control'
                value={this.props.body}
              />
            </div>
          </div>
        </Collapse>
      </div>
    )
  }
}

export default BotQuestion
