class RemindersController < ApplicationController
  before_action :build_event_at, only: %i[create update]
  helper_method :conversation_path

  def new
    @reminder = authorize(contact.reminders.build)
  end

  def edit
    @reminder = authorize(contact.reminders.find(params[:id]))
  end

  def create
    @reminder = authorize(new_reminder)

    if Reminder::Create.call(@reminder)
      redirect_to conversation_path
    else
      render :new
    end
  end

  def update
    @reminder = authorize(contact.reminders.find(params[:id]))

    if Reminder::Update.call(@reminder, update_params)
      redirect_to conversation_path
    else
      render :edit
    end
  end

  def destroy
    @reminder = authorize(contact.reminders.find(params[:id]))

    Reminder::Destroy.call(@reminder)
    redirect_to conversation_path
  end

  private

  def conversation
    contact.current_conversation
  end

  def conversation_path
    inbox_conversation_path(conversation.inbox, conversation)
  end

  def build_event_at
    seed_event_at if date.present? && time.present?
  end

  def seed_event_at
    params[:reminder][:event_at] = fetch_event_at
  end

  def fetch_event_at
    Time.zone.local(
      date.year, date.month, date.day,
      time.hour, time.min, time.sec
    )
  end

  def date
    return if params[:date].blank?
    Date.strptime(params[:date], '%d/%m/%Y')
  end

  def time
    return if params[:time].blank?
    Time.strptime(params[:time], '%l:%M%p')
  end

  def update_params
    permitted_attributes(Reminder)
  end

  def new_reminder
    contact.reminders.build(permitted_attributes(Reminder))
  end

  def contact
    @contact ||= begin
      authorize(Contact.find(params[:contact_id]), :show?)
    end
  end
end
