import React from 'react'

class SegmentLink extends React.Component {
  render() {
    return (
      <a role="button" tabIndex={0}>
        <i className={`fa mr-2 ${this.props.icon}`}></i>
        {this.props.name}
      </a>
    )
  }
}

SegmentLink.defaultProps = {
  icon: 'fa-pie-chart'
}

export default SegmentLink
