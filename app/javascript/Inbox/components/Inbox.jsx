import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import InboxListItem from './InboxListItem'

const Inbox = props => (
  <div className="Inbox">
    <InboxListItem />
    <InboxListItem />
    <InboxListItem />
    <InboxListItem />
    <InboxListItem />
  </div>
)

export default Inbox
