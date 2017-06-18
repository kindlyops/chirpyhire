import React from 'react'

import InboxLink from './inboxLink'

class Inboxes extends React.Component {

  render() {
    return (
      <div className='Inboxes pl-3'>
        <InboxLink {...this.props.inbox}
          key={`account-${this.props.inbox.id}`}
          name={'You'}
          icon={'fa-user'}
          handleInboxChange={this.props.handleInboxChange}
        />
        {
          this.props.team_inboxes.map((inbox) =>
            <InboxLink 
              {...inbox}
              key={`team-${inbox.id}`}
              handleInboxChange={this.props.handleInboxChange} 
            />
          )
        }
      </div>
    )
  }
}

export default Inboxes
