class CreateBumps < ActiveRecord::Migration
  def change
    create_table :bumps do |t|
      t.references :user
      t.references :band

      t.timestamps
    end
    add_index :bumps, :user_id
    add_index :bumps, :band_id
  end
end
