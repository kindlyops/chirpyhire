class AddsUrlAndEmailToOrganizations < ActiveRecord::Migration[5.1]
  def change
    change_table :organizations do |t|
      t.string :url
      t.string :email
      t.string :billing_email
      t.string :description
    end
  end
end
