class OrganizationQuestionCategory < ActiveRecord::Base
  belongs_to :question_category
  belongs_to :organization
end
