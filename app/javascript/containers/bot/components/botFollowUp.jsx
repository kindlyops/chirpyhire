import React from 'react'

class BotFollowUp extends React.Component {
  actionClasses() {
    switch(this.props.action) {
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
  render() {
    return(<div className='FollowUp mb-2'>
            <input 
              name="bot[questions_attributes][][follow_ups_attributes][][body]"
              type="text"
              className='form-control'
              id={this.props.id}
              data-question-id={this.props.question_id}
              value={this.props.body}
              onChange={this.props.onChange}
              placeholder='Add a follow up...'
            />
            <div className='FollowUp--footer'>
              <div className='FollowUp--details'>
                <span className='FollowUp--response badge badge-default'>
                  {this.props.response}
                </span>
                <span className={this.actionClasses()}>
                  {this.props.humanized_action}
                </span>
                <span className='FollowUp--tags'>
                  {this.props.tags.map(tag =>
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
                <a role="button">
                  <i className='fa fa-trash-o'></i>
                </a>
              </div>
            </div>
          </div>)
  }
}

export default BotFollowUp
