class NotesController < ApplicationController
  decorates_assigned :conversation
  decorates_assigned :notes
  decorates_assigned :note

  def index
    @notes = policy_scope(contact.notes)

    respond_to do |format|
      format.json
    end
  end

  def update
    @note = authorized_note
    @note.update(permitted_attributes(Note))

    Broadcaster::Note.broadcast(note)
    head :ok
  end

  def create
    @note = authorize new_note
    @note.save

    Broadcaster::Note.broadcast(note)
    head :created
  end

  def destroy
    @note = authorized_note
    @note.destroy

    Broadcaster::Note.broadcast(note)
    head :no_content
  end

  private

  def authorized_note
    authorize(contact.notes.find(params[:id]))
  end

  def contact
    @contact ||= authorize Contact.find(params[:contact_id]), :show?
  end

  def new_note
    contact.notes.build(new_note_attributes)
  end

  def new_note_attributes
    permitted_attributes(Note).merge(account: current_account)
  end
end
