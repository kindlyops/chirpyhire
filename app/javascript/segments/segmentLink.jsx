import React from 'react'

import { NavLink } from 'react-router-dom'

class SegmentLink extends React.Component {
  href() {
    return `/candidates/segments/${this.props.id}`;
  }

  render() {
    return (
      <NavLink exact to={this.href()} role="button">
        <i className={`fa mr-2 ${this.props.icon}`}></i>
        {this.props.name}
      </NavLink>
    )
  }
}

SegmentLink.defaultProps = {
  icon: 'fa-pie-chart'
}

export default SegmentLink
