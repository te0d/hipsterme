class CreateListens < ActiveRecord::Migration
  def change
    create_table :listens do |t|
      t.references :band
      t.integer :count

      t.timestamps
    end
    add_index :listens, :band_id
  end
end
