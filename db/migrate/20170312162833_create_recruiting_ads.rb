class CreateRecruitingAds < ActiveRecord::Migration[5.0]
  def change
    create_table :recruiting_ads do |t|
      t.references :organization, null: false, index: true, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
