import React from 'react'


class CandidateSegment extends React.Component {
  constructor(props) {
    super(props);

    this.handleSegmentChange = this.handleSegmentChange.bind(this);
  }

  handleSegmentChange() {
    this.props.handleSegmentChange(this.props.form);
  }

  render() {
    return (
      <a role="button" tabIndex={0} onClick={this.handleSegmentChange}>
        <i className={`fa mr-2 ${this.props.icon}`}></i>
        {this.props.name}
      </a>
    )
  }
}

CandidateSegment.defaultProps = {
  icon: 'fa-pie-chart'
}

export default CandidateSegment
