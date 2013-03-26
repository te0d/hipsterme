class AddAvailableCredToUser < ActiveRecord::Migration
  def change
    add_column :users, :available_cred, :decimal, :precision => 15, :scale => 2, :default => 100.00
  end
end
