class DropsScreenedFromCandidates < ActiveRecord::Migration[5.0]
  def change
    remove_column :candidates, :screened, :boolean
  end
end
