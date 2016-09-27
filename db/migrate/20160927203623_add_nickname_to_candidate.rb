class AddNicknameToCandidate < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :nickname, :string
  end
end
