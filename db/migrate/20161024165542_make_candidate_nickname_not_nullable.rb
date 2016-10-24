class MakeCandidateNicknameNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:candidates, :nickname, false)
  end
end
