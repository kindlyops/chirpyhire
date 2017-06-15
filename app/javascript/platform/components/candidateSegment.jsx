import React from 'react'

const CandidateSegment = props => (
  <a role="button" className='CandidateSegment' href="#">
    <i className='fa fa-pie-chart mr-2'></i>
    {props.name}
  </a>
)

export default CandidateSegment
