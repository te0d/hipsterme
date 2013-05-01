class AddLastFmDescToBands < ActiveRecord::Migration
  def change
    add_column :bands, :lastfm_desc, :text
  end
end
