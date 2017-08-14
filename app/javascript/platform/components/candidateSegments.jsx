import React from 'react'

import CandidateSegment from './candidateSegment'

class CandidateSegments extends React.Component {
  render() {
    return (
      <div className='ch--SecondaryHeader'>
        {
          this.props.segments.map((segment) =>
            <CandidateSegment 
              {...segment}
              key={segment.id}
              handleSegmentChange={this.props.handleSegmentChange} 
            />
          )
        }
      </div>
    )
  }
}

export default CandidateSegments
