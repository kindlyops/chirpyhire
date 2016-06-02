class UserFeature < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile_feature
  has_many :inquiries

  delegate :document?, to: :profile_feature
  delegate :format, :name, to: :profile_feature, prefix: true

  def inquire
    message = user.receive_message(body: body)
    inquiries.create(message: message)
  end

  def body
    "Please send a photo of your #{profile_feature.name}" if document?
  end
end
