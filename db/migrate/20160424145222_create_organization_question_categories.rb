class CreateOrganizationQuestionCategories < ActiveRecord::Migration
  def change
    create_table :organization_question_categories do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.belongs_to :question_category, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
