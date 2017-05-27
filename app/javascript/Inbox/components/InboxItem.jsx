import React from 'react'

class InboxItem extends React.Component {
  render() {
    return <a href={'/messages/' + this.props.contact_id} className="InboxItem">
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
      <div className='summary'>
        {this.props.summary}
      </div>
    </a>;
  }
}

export default InboxItem
