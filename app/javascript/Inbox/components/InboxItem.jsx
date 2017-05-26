import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const InboxItem = props => (
  <div className="InboxItem">
    <div className='handle-and-timestamp'>
      <div className='handle'>
        Affable Leopard
      </div>
      <div className='timestamp-container'>
        <div className='timestamp'>
          05/16/2017
        </div>
      </div>
    </div>
    <div className='summary'>
      Woohoo! 🎉
    </div>
  </div>
)

export default InboxItem
