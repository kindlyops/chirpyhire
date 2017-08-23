import React from 'react'

import Segments from '../segments'
import { Route } from 'react-router-dom'

class Candidates extends React.Component {
  render() {
    return (
      <div className='Platform ch--Page'>
        <div className='ch--Header'>
          <h1>Caregivers</h1>
        </div>
        <Route path={this.props.match.url + '/segments'} component={Segments} />
      </div>
    )
  }
}

export default Candidates
