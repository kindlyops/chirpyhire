import React from 'react'

const InboxDropdown = props => (
  <div className="InboxDropdown">
    <div className="view-title">
      <div className="view-count">
        <span className='badge badge-default'>{props.conversations_count}</span>
      </div>
      <div className="view-name">
      All
      </div>
    </div>
  </div>
)

export default InboxDropdown
