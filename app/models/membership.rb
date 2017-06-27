class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :team

  delegate :avatar, :person, :name, :handle, to: :account
end
