# frozen_string_literal: true
class Notification < ApplicationRecord
  include Messageable
  belongs_to :template
end
