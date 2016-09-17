# frozen_string_literal: true
class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.string :body, null: false
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :templates, [:body, :organization_id], unique: true
    add_index :templates, [:name, :organization_id], unique: true
  end
end
