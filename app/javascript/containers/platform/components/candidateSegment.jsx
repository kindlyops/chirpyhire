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
        <i className='fa fa-pie-chart mr-2'></i>
        {this.props.name}
      </a>
    )
  }
}

export default CandidateSegment
