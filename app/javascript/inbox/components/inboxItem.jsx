import React from 'react'
import { NavLink } from 'react-router-dom'

class InboxItem extends React.Component {
  href() {
    return `/inboxes/${this.props.inboxId}/conversations/${this.props.conversation_id}`;
  }

  inactive() {
    return parseInt(this.props.match.params.id) !== this.props.id;
  }

  unread() {
    return this.props.unread_count > 0;
  }

  render() {
    let summary = <div className='summary-and-unread-count'>
                    <div className='summary'>
                      {this.props.summary}
                    </div>
                  </div>;
    if(this.unread() && this.inactive()) {
      summary = <div className='summary-and-unread-count'>
                  <div className='summary'>
                    {this.props.summary}
                  </div>
                  <div className='badge badge-success unread-count'>
                    {this.props.unread_count}
                  </div>
                </div>
    }

    return <NavLink exact to={this.href()} className='InboxItem'>
      <div className='handle-and-timestamp'>
        <div className='handle'>
          {this.props.handle}
        </div>
        <div className='timestamp-container'>
          <div className='timestamp'>
            {this.props.timestamp}
          </div>
        </div>
      </div>
      {summary}
    </NavLink>;
  }
}

export default InboxItem
