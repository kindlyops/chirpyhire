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
        <Route path={this.props.match.url + '/:id'} component={Segment} />
      </div>
    )
  }

}

export default Segments
