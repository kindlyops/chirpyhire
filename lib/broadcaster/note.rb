class Broadcaster::Note
  def self.broadcast(note)
    new(note).broadcast
  end

  def initialize(note)
    @note = note
  end

  def broadcast
    NotesChannel.broadcast_to(contact, note_hash)
  end

  private

  attr_reader :note

  delegate :contact, to: :note

  def note_hash
    JSON.parse(note_string)
  end

  def note_string
    NotesController.render partial: 'notes/note.json.jbuilder', locals: {
      note: note
    }
  end
end
