class Answer < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :message
end
