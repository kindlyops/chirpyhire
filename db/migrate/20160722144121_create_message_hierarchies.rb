class CreateMessageHierarchies < ActiveRecord::Migration
  def change
    create_table :message_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :message_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "message_anc_desc_idx"

    add_index :message_hierarchies, [:descendant_id],
      name: "message_desc_idx"
  end
end
