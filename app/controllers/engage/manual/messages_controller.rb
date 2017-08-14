class Engage::Manual::MessagesController < ApplicationController
  def index
    @campaigns = policy_scope(ManualMessage)

    respond_to do |format|
      format.json
      format.html
    end
  end

  def create
    @new_manual_message = authorize new_manual_message

    run_and_send_notification if @new_manual_message.save
    head :ok
  end

  private

  def run_and_send_notification
    Broadcaster::Notification.broadcast(current_account, notification)
    create_participants
    ManualMessageJob.perform_later(@new_manual_message)
  end

  def create_participants
    filtered_contacts.find_each do |contact|
      @new_manual_message.participants.create(contact: contact)
    end
  end

  def new_manual_message
    current_account.manual_messages.build(permitted_attributes(ManualMessage))
  end

  def filtered_contacts
    return scope if audience_params.blank?

    scope
      .contact_stage_filter(contact_stage_params)
      .campaigns_filter(campaigns_params)
      .name_filter(name_params)
      .tag_filter(tag_params)
      .zipcode_filter(zipcode_params)
      .messages_filter(messages_params)
  end

  def scope
    policy_scope(Contact)
  end

  def permitted_params
    params.permit(manual_message: [audience: audience_params_keys])
  end

  def audience_params_keys
    %i[city state county zipcode name messages]
      .concat([tag: [], contact_stage: [], campaigns: []])
  end

  def audience_params
    permitted_params.to_h[:manual_message][:audience]
  end

  def campaigns_params
    audience_params[:campaigns]
  end

  def messages_params
    audience_params[:messages]
  end

  def name_params
    audience_params[:name]
  end

  def tag_params
    audience_params[:tag]
  end

  def contact_stage_params
    audience_params[:contact_stage]
  end

  def zipcode_params
    result = audience_params.slice(:state, :city, :county, :zipcode)
    result[:county_name]        = result.delete(:county) if result[:county]
    result[:default_city]       = result.delete(:city)   if result[:city]
    result[:state_abbreviation] = result.delete(:state)  if result[:state]

    result
  end

  def notification
    {
      message: 'Your message is now sending',
      key: SecureRandom.uuid
    }
  end
end
