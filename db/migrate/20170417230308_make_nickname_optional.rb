class MakeNicknameOptional < ActiveRecord::Migration[5.0]
  def change
    change_column_null :people, :nickname, true
  end
end
