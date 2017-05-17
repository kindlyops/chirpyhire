class AddAttachmentAvatarToPeople < ActiveRecord::Migration[4.2]
  def self.up
    change_table :people do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :people, :avatar
  end
end
