class CreateUserFeatures < ActiveRecord::Migration
  def change
    create_table :user_features do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :profile_feature, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_reference :inquiries, :user_feature, null: false, index: true, foreign_key: true
  end
end
