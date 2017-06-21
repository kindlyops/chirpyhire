import React from 'react'

import CandidateSegment from './candidateSegment'
import update from 'immutability-helper'

class CandidateSegments extends React.Component {
  render() {
    return (
      <div className='pl-3 ch--SecondaryHeader'>
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
