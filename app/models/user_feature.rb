class UserFeature < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile_feature
  has_many :inquiries

  delegate :name, to: :profile_feature, prefix: true
  delegate :format, to: :profile_feature

  def inquire
    message = user.receive_message(body: profile_feature.question)
    inquiries.create(message: message)
  end

  def child_class
    properties['child_class'] || "user_feature"
  end
end
