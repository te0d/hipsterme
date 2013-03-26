class AddCredColumnsToBump < ActiveRecord::Migration
  def change
    add_column :bumps, :unbumped_at, :datetime, :default => nil
    add_column :bumps, :invested_cred, :decimal, :precision => 15, :scale => 2, :default => 0.0
    add_column :bumps, :cred_value, :decimal, :precision => 15, :scale => 2, :default => 0.0
  end
end
