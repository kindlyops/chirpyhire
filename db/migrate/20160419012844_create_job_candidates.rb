class CreateJobCandidates < ActiveRecord::Migration
  def change
    create_table :job_candidates do |t|
      t.belongs_to :job, null: false, index: true, foreign_key: true
      t.belongs_to :candidate, null: false, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :fit, null: false, default: 0
      t.timestamps null: false
    end
  end
end
