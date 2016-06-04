class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :taskable, polymorphic: true

  delegate :organization, to: :user

  scope :outstanding, -> { where(outstanding: true) }

  def has_chirp?
    taskable_type == "Chirp"
  end
end
