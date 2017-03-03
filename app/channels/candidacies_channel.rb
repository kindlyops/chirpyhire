class CandidaciesChannel < ApplicationCable::Channel
  def subscribed
    reject unless candidacy.present?
    stream_for candidacy
  end

  delegate :contacts, to: :current_organization
  delegate :candidacy, to: :contact

  private

  def contact
    @contact ||= contacts.find(params[:contact_id])
  end
end
