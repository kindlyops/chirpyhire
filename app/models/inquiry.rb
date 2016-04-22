class Inquiry < ActiveRecord::Base
  belongs_to :message
  belongs_to :question
  belongs_to :lead
end
