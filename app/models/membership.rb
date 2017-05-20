class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :team

  enum role: {
    member: 0, manager: 1
  }
end
