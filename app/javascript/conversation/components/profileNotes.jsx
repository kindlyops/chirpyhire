import React from 'react'
import moment from 'moment'
import update from 'immutability-helper'

import NoteDay from './noteDay'

class ProfileNotes extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      notes: [],
      subscription: {}
    };
  }

  render() {
    return (
        <div className="profile-notes">
          <div className="section-title">
            <span>Notes ({this.state.notes.length})</span>
          </div>
          <div id="notes_container">
            <div>
              <div className="notes">
                {this.days().map((day) =>
                  <NoteDay key={day[0].created_at} notes={day} day={day[0].created_at} />
                )}
              </div>
            </div>
            <div id="reply_container">
              <span className="author_image thumb_36 second hp-anchors-away"></span>
              <div className="inline_message_input_container">
                <form className="new_note" id="new_note" action={`/contacts/${this.props.contact.id}/notes`} acceptCharset="UTF-8" method="post" data-remote="true">
                  <input name="utf8" type="hidden" value="✓" />
                  <div className="message_input">
                    <textarea rows="1" placeholder="Share a note with your team..." required="required" className="form-control" name="note[body]" id="note_body"></textarea>
                  </div>
                  <div className="reply_container_info">
                    <div className="reply_broadcast_buttons_container justify-content-end">
                      <button className="note_send btn btn-small btn-outline" type="submit">Save</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      )
  }

  componentWillReceiveProps(nextProps) {
    if(nextProps.contact.id && nextProps.contact.id !== this.props.contact.id) {
      this.load(nextProps.contact.id);
      this.reconnect(nextProps.contact.id);
    }
  }

  componentDidMount() {
    if(this.props.contact.id) {
      this.load(this.props.contact.id);
      this.connect(this.props.contact.id);
    }
    this._init();
  }

  load(id) {
    $.get(this.notesUrl(id)).then((notes) => {
      this.setState({ notes: notes });
    });
  }

  notesUrl(id) {
    return `/contacts/${id}/notes`;
  }

  connect(id) {
    let channel = { channel: 'NotesChannel', contact_id: id };
    let subscription = App.cable.subscriptions.create(
      channel, this._channelConfig()
    );

    this.setState({ subscription: subscription });
  }

  days() {
    return R.groupWith(this._sameDay, this.state.notes);
  }

  reconnect(id) {
    this.disconnect();
    this.connect(id);
  }

  disconnect() {
    App.cable.subscriptions.remove(this.state.subscription);
  }

  _sameDay(first, second) {
    let firstMoment = moment(first.created_at);
    let secondMoment = moment(second.created_at);

    return firstMoment.isSame(secondMoment, 'day');
  }

  _channelConfig() {
    return {
      received: this._received.bind(this)
    }
  }
 
  _received(receivedNote) {
    let notes;
    const index = this.state.notes.findIndex((note) => note.id === receivedNote.id);

    if (Number.isInteger(index)) {
      if(receivedNote.deleted_at) {
        notes = update(this.state.notes, { $splice: [[index, 1]] });
        $(`#note-edit-container[data-note-id="${receivedNote.id}"]`).remove();
        $(`#note-show-container[data-note-id="${receivedNote.id}"]`).remove();
      } else {
        notes = update(this.state.notes, { $splice: [[index, 1, receivedNote]] });
        $(`#note-edit-container[data-note-id="${receivedNote.id}"]`).prop('hidden', true);
        $(`#note-show-container[data-note-id="${receivedNote.id}"]`).removeProp('hidden');
      }
    } else {
      notes = update(this.state.notes, { $push: [receivedNote] });
      $('#reply_container textarea').val('');
    }

    this.setState({ notes: notes });
  }

  _init() {
    $(document).on('focus', '#reply_container textarea', function() {
      $('#reply_container').addClass('has_focus');
    });

    $(document).on('focusout', '#reply_container textarea', function() {
      if(!$('#reply_container textarea').val().trim().length) {
        $('#reply_container textarea').val('');
        $('#reply_container').removeClass('has_focus');
      }
    });

    $(document).on('click', '#note-show-container button.delete', function(e) {
      var noteToDelete = $(this).closest('#note-show-container').clone();
      noteToDelete.addClass('standalone');

      var modal = $('.modal');
      var notice = '<p class="mb-3">Are you sure you want to delete this note? This cannot be undone.</p>';
      modal.find('.modal-body').empty().append(notice).append(noteToDelete);
      modal.modal();

      modal.on('click', '.modal-footer button.delete', function(e) {
        e.preventDefault();
        noteToDelete.find('form.destroy-note').submit();
        modal.modal('hide');
      });
    });

    $(document).on('click', '#note-show-container button.edit', function(e) {
      var noteId = $(this).closest('#note-show-container').data('note-id');
      $(this).closest('#note-show-container').prop('hidden', true);
      $('#note-edit-container[data-note-id="'+ noteId + '"').removeProp('hidden');
    });

    $(document).on('click', '#note-edit-container #cancel_edit', function(e) {
      var noteId = $(this).closest('#note-edit-container').data('note-id');
      $(this).closest('#note-edit-container').prop('hidden', true);
      $('#note-show-container[data-note-id="'+ noteId + '"').removeProp('hidden');
    });

    $(document).on('keydown', '#note-edit-container #note_body', function(e) {
      var body = $('#note-edit-container #note_body').val().trim();
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo && body.length) {
        e.preventDefault();
        $(this).closest('form').submit();
      }
    });

    $(document).on('keydown', '#new_note #note_body', function(e) {
      var body = $('#new_note #note_body').val().trim();
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo && body.length) {
        e.preventDefault();
        $(this).closest('form').submit();
      }
    });
  }
}

export default ProfileNotes
