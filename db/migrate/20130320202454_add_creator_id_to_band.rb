class AddCreatorIdToBand < ActiveRecord::Migration
  def change
    add_column :bands, :creator_id, :integer
  end
end
