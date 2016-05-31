class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :event, null: false
      t.timestamps null: false
    end
  end
end
