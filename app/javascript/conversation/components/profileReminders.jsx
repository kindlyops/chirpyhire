import React from 'react'
import ProfileReminder from './profileReminder'

class ProfileReminders extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='form-group mt-3'>
        <strong>Reminders:</strong>
        {this.props.reminders.map(reminder => 
          <ProfileReminder key={reminder.id} reminder={reminder} contact={this.props.contact} />
        )}
        <div className='mt-2'>
          <i className='fa fa-clock-o mr-1 text-dark'></i>
          <a href={`/contacts/${this.props.contact.id}/reminders/new`} role='button'>Add Reminder</a>
        </div>
      </div>
    )
  }
}

ProfileReminders.defaultProps = {
  reminders: [],
  contact: {}
}

export default ProfileReminders
