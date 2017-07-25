class AddsNameAndNicknameToContact < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.string :nickname
      t.string :name
    end

    add_index :contacts, [:organization_id, :nickname], unique: true
  end
end
