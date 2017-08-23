import React from 'react'

import InboxLink from './inboxLink'

class Inboxes extends React.Component {

  render() {
    return (
      <div className='Inboxes pl-3'>
        {
          this.props.inboxes.map(inbox =>
            <InboxLink 
              {...inbox} 
              key={`${inbox.id}`} />
          )
        }
      </div>
    )
  }
}

export default Inboxes
