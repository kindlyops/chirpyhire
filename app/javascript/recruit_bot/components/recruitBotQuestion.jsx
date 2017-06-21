import React from 'react'
import Toggle from 'react-toggle'

class RecruitBotQuestion extends React.Component {
  constructor(props) {
    super(props);

    this.toggleQuestion = this.toggleQuestion.bind(this);
    this.isActive = this.isActive.bind(this);
  }

  organizationId() {
    return this.props.current_organization.id;
  }

  organizationURL() {
    return `/organizations/${this.organizationId()}.json`;
  }

  data() {
    return JSON.stringify({
      organization: {
        [this.props.type]: !this.isChecked()
      }
    })
  }

  toggleQuestion() {
    $.ajax({
      url: this.organizationURL(),
      type: 'PUT',
      data: this.data(),
      dataType: 'json',
      accepts: 'application/json',
      contentType: 'application/json'
    });
  }

  isChecked() {
    return !!this.props.current_organization[this.props.type];
  }

  keys() {
    return ['certification', 'availability', 'live_in', 'experience',
            'transportation', 'zipcode', 'cpr_first_aid', 'skin_test'];
  }

  isDisabled() {
    return this.isChecked() && R.reduce(this.isActive, 0, this.keys()) <= 1;
  }

  isActive(count, key) {
    if (this.props.current_organization[key]) {
      return count + 1;
    } else {
      return count;
    }
  }

  render() {
    return (
      <div className='card'>
        <div className='card-header'>
          <span className='question'>{`Question: ${this.props.question}`}</span>
          <label className='toggle'>
            <Toggle
              checked={this.isChecked()}
              disabled={this.isDisabled()}
              onChange={this.toggleQuestion} />
          </label>
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

export default RecruitBotQuestion
