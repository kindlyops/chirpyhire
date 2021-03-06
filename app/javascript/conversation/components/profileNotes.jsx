import React from 'react'
import moment from 'moment'
import update from 'immutability-helper'
import PropTypes from 'prop-types'
import Textarea from 'react-textarea-autosize'
import NoteDay from './noteDay'

class ProfileNotes extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      notes: [],
      subscription: {},
      value: ''
    };

    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);
    this.createNote = this.createNote.bind(this);
  }

  senderIcon() {
    if(this.context.current_account.url) {
      return (
        <img className='author_image no-repeat thumb_36' src={this.context.current_account.url}></img>
      );
    } else {
      return (
        <span className={`author_image thumb_36 ${this.context.current_account.hero_pattern_classes}`}>
        </span>
      );
    }
  }

  inputContainerClasses() {
    if (this.context.current_account.url) {
      return 'inline_message_input_container less-negative-margin-top';
    } else {
      return 'inline_message_input_container';
    }
  }

  newNoteUrl() {
    return `/contacts/${this.props.contact.id}/notes`;
  }

  onSubmit(e) {
    e.preventDefault();
    this.createNote();
  }

  createNote() {
    const params = {
      _method: 'post',
      note: { body: this.state.value }
    };

    const config = {
      url: this.newNoteUrl(),
      data: params,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }

    $.ajax(config).then(() => {
      this.setState({ value: '' });
    });
  }

  onChange(event) {
    this.setState({ value: event.target.value })
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
                  <NoteDay key={day[0].created_at} current_account={this.context.current_account} notes={day} day={day[0].created_at} />
                )}
              </div>
            </div>
            <div id="reply_container">
              {this.senderIcon()}
              <div className={this.inputContainerClasses()}>
                <form onSubmit={this.onSubmit} className="new_note" id="new_note">
                  <div className="message_input">
                    <Textarea onChange={this.onChange} rows="1" value={this.state.value} placeholder="Share a note with your team..." required="required" className="form-control" name="note[body]" id="note_body"></Textarea>
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
    const index = R.findIndex((note) => (note.id === receivedNote.id), this.state.notes);

    if (index !== -1) {
      if(receivedNote.deleted_at) {
        notes = update(this.state.notes, { $splice: [[index, 1]] });
        $(`#note-edit-container[data-note-id="${receivedNote.id}"]`).remove();
        $(`#note-show-container[data-note-id="${receivedNote.id}"]`).remove();
      } else {
        notes = update(this.state.notes, { $splice: [[index, 1, receivedNote]] });
        $(`#note-edit-container[data-note-id="${receivedNote.id}"]`).prop('hidden', true);
        $(`#note-show-container[data-note-id="${receivedNote.id}"]`).removeProp('hidden');
      }
    } else if (!receivedNote.deleted_at) {
      notes = update(this.state.notes, { $push: [receivedNote] });
      $('#reply_container textarea').val('');
    }

    this.setState({ notes: notes });
  }

  componentWillUnmount() {
    this.disconnect();
    this._deinit();
  }

  _deinit() {
    let modal = $('.modal');
    modal.off('click', '.modal-footer button.delete');
    $(document).off('focus', '#reply_container textarea');
    $(document).off('focusout', '#reply_container textarea');
    $(document).off('click', '#note-show-container button.delete');
    $(document).off('click', '#note-show-container button.edit');
    $(document).off('click', '#note-edit-container #cancel_edit');
    $(document).off('keydown', '#note-edit-container #note_body');
    $(document).off('keydown', '#new_note #note_body');
  }

  _init() {
    let modal = $('.modal').modal({ show: false });
    modal.on('click', '.modal-footer button.delete', function(e) {
      e.preventDefault();
      modal.modal('hide');
      let formId = modal.find('p[data-id]').data('id');
      modal.find(`form.destroy-note#${formId}`).submit();
    });

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
      let formId = noteToDelete.find('form.destroy-note').attr('id');
      var notice = `<p data-id="${formId}" class="mb-3">Are you sure you want to delete this note? This cannot be undone.</p>`;
      modal.find('.modal-body').empty().append(notice).append(noteToDelete);
      modal.modal('show');
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

    $(document).on('keydown', '#new_note #note_body', (e) => {
      var body = $('#new_note #note_body').val().trim();
      var combo = e.metaKey || e.ctrlKey || e.shiftKey;

      if(e.keyCode === 13 && !combo && body.length) {
        e.preventDefault();
        this.createNote();
      }
    });
  }
}

ProfileNotes.contextTypes = {
  current_account: PropTypes.object
}

export default ProfileNotes
