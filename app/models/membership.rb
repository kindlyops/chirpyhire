class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :team

  delegate :avatar, :person, :name, :handle, to: :account

  enum role: {
    member: 0, manager: 1
  }
end
