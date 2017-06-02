class NotesController < ApplicationController
  layout 'conversations', only: 'index'
  decorates_assigned :conversation

  before_action :authorize_conversation

  def index
    @notes = policy_scope(contact.notes)
  end

  def update
    @note = authorized_note

    if @note.update(permitted_attributes(Note))
      redirect_to notes_path, notice: 'Nice! Note saved.'
    else
      render :index
    end
  end

  def create
    @note = authorize new_note

    if @note.save
      redirect_to notes_path, notice: 'Nice! Note saved.'
    else
      render :index
    end
  end

  def destroy
    @note = authorized_note
    @note.destroy

    redirect_to notes_path, notice: 'Note was successfully deleted.'
  end

  private

  def authorized_note
    authorize(contact.notes.find(params[:id]))
  end

  def authorize_conversation
    @conversation = authorize fetch_conversation, :show?
  end

  def notes_path
    inbox_conversation_path(current_inbox, @conversation)
  end

  def fetch_conversation
    current_account.conversations.find_by(contact: contact)
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
