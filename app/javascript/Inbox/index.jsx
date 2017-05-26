import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import Inbox from './components/Inbox'
import InboxDropdown from './components/InboxDropdown'

const InboxWrapper = props => (
  <div className="InboxWrapper">
    <InboxDropdown />
    <Inbox />
  </div>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <InboxWrapper />,
    $('<div></div>').prependTo($('.messages'))[0],
  )
})
