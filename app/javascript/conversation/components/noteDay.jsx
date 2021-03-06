import React from 'react'
import Note from './note'

class NoteDay extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className="day_container">
        {this.props.notes.map((note) => <Note current_account={this.props.current_account} key={note.id} note={note} />)}
      </div>
    )
  }
}

export default NoteDay
