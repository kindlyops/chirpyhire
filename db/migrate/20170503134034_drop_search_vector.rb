class DropSearchVector < ActiveRecord::Migration[5.0]
  def change
    remove_column :contacts, :content
    remove_column :contacts, :content_tsearch
    remove_column :contacts, :not_ready_content
    remove_column :contacts, :not_ready_content_tsearch
    remove_column :contacts, :screened
  end
end
