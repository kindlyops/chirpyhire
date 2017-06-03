import React from 'react'
import { NavLink } from 'react-router-dom'

class InboxItem extends React.Component {
  href() {
    return `/inboxes/${this.props.inboxId}/conversations/${this.props.id}`;
  }

  render() {
    let summary = <div className='summary-and-unread-count'>
                    <div className='summary'>
                      {this.props.summary}
                    </div>
                  </div>;

    if(this.props.unread_count > 0) {
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
