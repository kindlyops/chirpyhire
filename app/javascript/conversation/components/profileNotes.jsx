import React from 'react'

class ProfileNotes extends React.Component {
  render() {
    return (
        <div className="profile-notes">
          <div className="section-title">
            <span>Notes (0)</span>
          </div>
          <div id="notes_container">
            <div className="conversation">
              <div className="notes">
            </div>
          </div>
          <div id="reply_container">
            <span className="author_image thumb_36 second hp-anchors-away"></span>
            <div className="inline_message_input_container">
              <form className="new_note" id="new_note" action={`/contacts/${this.props.contact.id}/notes`} acceptCharset="UTF-8" method="post">
                <input name="utf8" type="hidden" value="✓" />
                <input type="hidden" name="authenticity_token" value="3oD+nHijL2aBwD7P7H3cIBB474ZlMiaY+012XtOkAp9BYFgvXa1ljBp/PCHI7j+k6Kr0kt75W8+1ij8/86SRNQ==" />
                <div className="message_input">
                  <textarea rows="1" placeholder="Share a note with your team..." required="required" className="form-control" name="note[body]" id="note_body"></textarea>
                </div>
              </form>
            </div>
            <div className="reply_container_info">
              <div className="reply_broadcast_buttons_container justify-content-end">
                <button className="note_send btn btn-small btn-outline" type="button">Save</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default ProfileNotes
