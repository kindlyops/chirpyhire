class CreateOrganizationQuestions < ActiveRecord::Migration
  def change
    create_table :organization_questions do |t|
      t.belongs_to :question, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
