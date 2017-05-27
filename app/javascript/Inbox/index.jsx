import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import Inbox from './components/inbox'
import InboxDropdown from './components/inboxDropdown'

const InboxWrapper = props => (
  <div className="InboxWrapper">
    <InboxDropdown />
    <Inbox />
  </div>
)

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('inbox')
  const data = JSON.parse(node.getAttribute('data'))

  ReactDOM.render(<InboxWrapper {...data} />, node)
})
