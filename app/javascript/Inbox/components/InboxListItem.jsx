import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const InboxListItem = props => (
  <div className="InboxListItem">
    <div className='handle-and-timestamp'>
      <div className='handle'>
        Affable Leopard
      </div>
      <div className='timestamp'>
        05/16/2017
      </div>
    </div>
    <div className='summary'>
      Woohoo! 🎉
    </div>
  </div>
)

export default InboxListItem
