class Band < ActiveRecord::Base
  attr_accessible :description, :mbid, :name, :image
  
  has_and_belongs_to_many :users
  
  has_attached_file :image
end
