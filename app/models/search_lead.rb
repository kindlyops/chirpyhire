class SearchLead < ActiveRecord::Base
  belongs_to :search
  belongs_to :lead
end
