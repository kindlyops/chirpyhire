class AddsRecruiterToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_reference :organizations, :recruiter, references: :accounts, index: true
    add_foreign_key :organizations, :accounts, column: :recruiter_id
  end
end
