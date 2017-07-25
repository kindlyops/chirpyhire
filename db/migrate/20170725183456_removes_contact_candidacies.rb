class RemovesContactCandidacies < ActiveRecord::Migration[5.1]
  def change
    drop_table :contact_candidacies
    drop_table :goals_tags

    remove_column :contacts, :screened
    remove_column :contacts, :reached
    remove_column :contacts, :outcome
    remove_column :contacts, :starred
    remove_column :organizations, :contacts_count
    remove_column :organizations, :screened_contacts_count
    remove_column :organizations, :reached_contacts_count
    remove_column :organizations, :starred_contacts_count
    remove_column :organizations, :certification
    remove_column :organizations, :availability
    remove_column :organizations, :live_in
    remove_column :organizations, :experience
    remove_column :organizations, :transportation
    remove_column :organizations, :drivers_license
    remove_column :organizations, :zipcode
    remove_column :organizations, :cpr_first_aid
    remove_column :organizations, :skin_test
    remove_column :teams, :recruiter_id

    remove_column :goals, :outcome
  end
end
