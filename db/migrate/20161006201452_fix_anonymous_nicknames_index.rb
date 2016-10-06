class FixAnonymousNicknamesIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :candidates, name: 'index_candidates_on_nickname'
    add_index :candidates, :nickname
  end
end
