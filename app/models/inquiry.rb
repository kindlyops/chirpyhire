class Inquiry < ActiveRecord::Base
  belongs_to :question
  belongs_to :message
end
