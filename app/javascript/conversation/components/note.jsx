import React from 'react'
import moment from 'moment'
import Textarea from 'react-textarea-autosize'

class Note extends React.Component {
  timestamp() {
    return moment(this.props.note.created_at).format('MMM Do, h:mm a');
  }

  fullTimestamp() {
    return moment(this.props.note.created_at).format('dddd, MMMM Do YYYY, h:mm:ss a');
  }

  noteUrl() {
    return `/contacts/${this.props.note.contact_id}/notes/${this.props.note.id}`;
  }

  editableNote() {
    return (
      <div title={this.fullTimestamp()}>
        <div className="message first highlight" id='note-edit-container' data-note-id={this.props.note.id} hidden={true}>
          <div className="message_gutter">
            <div className="message-icon">
              <div className={`author_image thumb_36 second ${this.props.note.sender_hero_pattern_classes}`}></div>
            </div>
          </div>
          <form className="edit_note" id={`edit_note_${this.props.note.id}`} action={this.noteUrl()} acceptCharset="UTF-8" method="post" data-remote="true">
            <input name="utf8" type="hidden" value="✓" />
            <input type="hidden" name="_method" value="put" />
            <div className="message_input">
              <Textarea rows="1" placeholder="Share a note with your team..." required="required" className="form-control" name="note[body]" id="note_body" style={{height: '2px'}} defaultValue={this.props.note.body}></Textarea>
            </div>
            <a className="btn btn-small btn-outline" id="cancel_edit" role="button">Cancel</a>
            <button className="btn btn-small btn-primary" id="commit_edit" role="button" type="submit">↵ Save Changes</button>
          </form>
        </div>
        <div className='message first' id='note-show-container' data-note-id={this.props.note.id}>
          <form className="destroy-note" hidden={true} id={`edit_note_${this.props.note.id}`} action={this.noteUrl()} acceptCharset="UTF-8" method="post" data-remote="true">
            <input name="utf8" type="hidden" value="✓" />
            <input type="hidden" name="_method" value="delete" />
          </form>
          <div className="action_hover_container stretch_btn_heights">
            <button className="btn-unstyle btn_msg_action edit" data-placement="top" data-toggle="tooltip" role="button" type="button" data-original-title="Edit note">
              <i className="fa fa-pencil"></i>
            </button>
            <button className="btn-unstyle btn_msg_action delete" data-placement="top" data-toggle="tooltip" role="button" type="button" data-original-title="Delete note">
              <i className="fa fa-trash"></i>
            </button>
          </div>
          <div className="message_gutter">
            <div className="message-icon">
              <div className={`author_image thumb_36 second ${this.props.note.sender_hero_pattern_classes}`}></div>
            </div>
            <a className="timestamp">{this.timestamp()}</a>
          </div>
          <div className="message_content">
            <div className="message_content_header">
              <div className="message_content_header_left">
                <strong className="message-sender">{this.props.note.sender_handle}</strong>
                <a className="timestamp">{this.timestamp()}</a>
              </div>
            </div>
            <span className="message-body">{this.props.note.body}</span>
          </div>
        </div>
      </div>
    )
  }

  nonEditableNote() {
    return (
      <div title={this.fullTimestamp()}>
        <div className='message first' id='note-show-container' data-note-id={this.props.note.id}>
          <div className="message_gutter">
            <div className="message-icon">
              <div className={`author_image thumb_36 second ${this.props.note.sender_hero_pattern_classes}`}></div>
            </div>
            <a className="timestamp">{this.timestamp()}</a>
          </div>
          <div className="message_content">
            <div className="message_content_header">
              <div className="message_content_header_left">
                <strong className="message-sender">{this.props.note.sender_handle}</strong>
                <a className="timestamp">{this.timestamp()}</a>
              </div>
            </div>
            <span className="message-body">{this.props.note.body}</span>
          </div>
        </div>
      </div>
    )
  }

  render() {
    if (this.props.note.sender_id === this.props.current_account.id) {
      return this.editableNote();
    } else {
      return this.nonEditableNote();
    }
  }
}

export default Note


