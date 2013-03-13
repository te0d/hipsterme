class Band < ActiveRecord::Base
  attr_accessible :description, :mbid, :name
  
  has_and_belongs_to_many :users
end
