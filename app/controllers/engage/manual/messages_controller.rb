class Engage::Manual::MessagesController < ApplicationController
  before_action :prepare_predicates, only: %i[create]

  def index
    @campaigns = policy_scope(ManualMessage)

    respond_to do |format|
      format.json
      format.html
    end
  end

  def create
    @q = policy_scope(Contact).ransack(@predicates)
    @contacts = @q.result(distinct: true)
    @new_manual_message = authorize new_manual_message

    run_and_send_notification if @new_manual_message.save
    head :ok
  end

  private

  def permitted_params
    params.require(:manual_message).permit(:title, :body, audience: [predicates:
      %i[type attribute value comparison]])
  end

  def prepare_predicates
    @predicates = Search::Predicates.call(fetch_predicates)
  end

  def fetch_predicates
    permitted_params[:audience][:predicates] || []
  end

  def run_and_send_notification
    Broadcaster::Notification.broadcast(current_account, notification)
    create_participants
    ManualMessageJob.perform_later(@new_manual_message)
  end

  def create_participants
    @contacts.find_each do |contact|
      @new_manual_message.participants.create(contact: contact)
    end
  end

  def new_manual_message
    current_account.manual_messages.build(permitted_attributes(ManualMessage))
  end

  def notification
    {
      message: 'Your message is now sending',
      key: SecureRandom.uuid
    }
  end
end
