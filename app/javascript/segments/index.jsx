import React from 'react'

import configuration from './configuration'
import SegmentLink from './segmentLink'
import Segment from '../segment'
import update from 'immutability-helper'
import { Route } from 'react-router-dom'

class Segments extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      segments: configuration
    }

    this.addSegment = this.addSegment.bind(this);
    this.fetchSegment = this.fetchSegment.bind(this);
  }

  componentDidMount() {
    $.get('/segments').then(segments => {
      let newState = update(this.state, { segments: { $push: segments }});
      this.setState(newState);  
    });
  }

  render() {
    return (
      <div className='ch--Section'>
        <div className='ch--SecondaryHeader'>
          {
            this.state.segments.map((segment) =>
              <SegmentLink {...segment} key={segment.id} />
            )
          }
        </div>
        <Route path={this.props.match.url + '/:id'} render={props => (
          <Segment fetchSegment={this.fetchSegment} addSegment={this.addSegment} {...props} />
        )} />
      </div>
    )
  }

  fetchSegment(id) {
    return _.find(this.state.segments, { id });
  }

  addSegment(segment) {
    const index = R.findIndex((s) => (s.id === segment.id), this.state.segments);
    let newState;
    if (index !== -1) {
      newState = update(this.state, { segments: { $splice: [[index, 1, segment]] }});
    } else {
      newState = update(this.state, { segments: { $push: [segment] }});
    }

    this.setState(newState); 
  }
}

export default Segments
