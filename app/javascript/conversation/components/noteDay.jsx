import React from 'react'
import Note from './note'
import Moment from 'moment'
import { extendMoment } from 'moment-range';
const moment = extendMoment(Moment);

class NoteDay extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className="day_container">
        {this.props.notes.map((note) => <Note key={note.id} note={note} />)}
      </div>
    )
  }
}

export default NoteDay
