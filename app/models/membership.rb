class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :team
end
