import React from 'react'

class ProfileReminder extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='mt-1'>
        <div className='d-flex justify-content-between'>
          <div>
            <span className='mr-1'>{this.props.reminder.formatted_day}</span>
            <span className='mr-1'>at {this.props.reminder.formatted_time}</span>
            <span className='mr-1'>{this.props.reminder.formatted_time_zone}</span>
          </div>
          <div>
            <a className='btn btn-small btn-outline mr-2' href={`/contacts/${this.props.contact.id}/reminders/${this.props.reminder.id}/edit`} role='button'><i className='i fa fa-pencil'></i></a>
            <a className='btn btn-small btn-outline' href={`/contacts/${this.props.contact.id}/reminders/${this.props.reminder.id}/remove`} role='button'><i className='i fa fa-times'></i></a>
          </div>
        </div>
      </div>
    )
  }
}

ProfileReminder.defaultProps = {
  reminder: {},
  contact: {}
}

export default ProfileReminder
