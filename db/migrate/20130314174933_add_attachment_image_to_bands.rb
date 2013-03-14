class AddAttachmentImageToBands < ActiveRecord::Migration
  def self.up
    change_table :bands do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :bands, :image
  end
end
