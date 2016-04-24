class ScopesQuestionsToIndustries < ActiveRecord::Migration
  def change
    add_reference :questions, :industry, null: false, index: true, foreign_key: true
  end
end
