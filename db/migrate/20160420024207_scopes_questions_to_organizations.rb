class ScopesQuestionsToOrganizations < ActiveRecord::Migration
  def change
    add_reference :questions, :organization, null: false, index: true, foreign_key: true
  end
end
