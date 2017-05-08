class AddsBrokerContactToCandidacies < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :broker_contact_id, :integer, index: true, foreign_key: true
  end
end
