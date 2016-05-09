class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.belongs_to :trigger, null: false, index: true, foreign_key: true
      t.references :actionable, polymorphic: true, index: true, null: false
      t.timestamps null: false
    end
  end
end
