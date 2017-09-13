class CreateJobSeekers < ActiveRecord::Migration[5.1]
  def change
    create_table :job_seekers do |t|
      t.string :email, null: false
      t.string :phone_number, null: false
      t.boolean :agreed_to_terms, null: false
      t.timestamps
    end
  end
end
