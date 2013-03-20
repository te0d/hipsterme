class Listen < ActiveRecord::Base
  belongs_to :band
  attr_accessible :count
end
