import React from 'react'

import Configuration from './configuration'
import SegmentLink from './segmentLink'
import Segment from '../segment'
import update from 'immutability-helper'
import { Route } from 'react-router-dom'

class Segments extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loaded: false,
      segments: []
    }

    this.add = this.add.bind(this);
    this.fetch = this.fetch.bind(this);
    this.fetchSegments = this.fetchSegments.bind(this);
  }

  componentDidMount() {
    this.configure().then(this.fetchSegments);
  }

  fetchSegments() {
    return $.get('/segments').then(segments => {

      let newState = _.reduce(segments, (state, segment) => {
        return this.upsertSegment(segment, state);
      }, this.state);

      newState = update(newState, { loaded: { $set: true }});
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
        {this.segment()}
      </div>
    )
  }

  segment() {
    if(this.state.loaded) {
      return (<Route path={this.props.match.url + '/:id'} render={props => (
        <Segment fetch={this.fetch} add={this.add} {...props} />
      )} />)
    }
  }

  fetch(id) {
    let castedId = parseInt(id);
    let segmentId = castedId ? castedId : id;

    return _.find(this.state.segments, { id: segmentId });
  }

  upsertSegment(segment, state) {
    const index = R.findIndex((s) => (s.id === segment.id), state.segments);
    if (index !== -1) {
      return update(state, { segments: { $splice: [[index, 1, segment]] }});
    } else {
      return update(state, { segments: { $push: [segment] }});
    }
  }

  add(segment) {
    let newState = upsertSegment(segment, this.state);
    this.setState(newState); 
  }

  configure() {
    return new Configuration().segments().then(segments => {
      this.setState({ segments: segments });
    });
  }
}

export default Segments
