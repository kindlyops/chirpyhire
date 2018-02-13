import React from 'react'

class ProfileEmail extends React.Component {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    this.props.onEmailChange(event);
  }

  render() {
    return (
      <div className='form-group mt-3'>
        <label id='email' className='col-form-label'><strong>Email:</strong></label>
        <input id='email' className='form-control' placeholder='hello@example.com' type="email" name="contact[email]" value={this.props.email || ''} onChange={this.onChange} />
      </div>
    )
  }
}

ProfileEmail.defaultProps = {
  email: ''
}

export default ProfileEmail
