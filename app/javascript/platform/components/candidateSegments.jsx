import React from 'react'

import CandidateSegment from './candidateSegment'
import update from 'immutability-helper'
import SecondaryHeader from '../../presentational/secondaryHeader'

class CandidateSegments extends React.Component {
  render() {
    return (
      <SecondaryHeader className='pl-3'>
        {
          this.props.segments.map((segment) =>
            <CandidateSegment 
              {...segment}
              key={segment.id}
              handleSegmentChange={this.props.handleSegmentChange} 
            />
          )
        }
      </SecondaryHeader>
    )
  }
}

export default CandidateSegments
