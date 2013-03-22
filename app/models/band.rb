class Band < ActiveRecord::Base
  attr_accessible :creator_id, :description, :mbid, :name, :image, :image_file_name
  
  has_many :bumps
  has_many :users, :through => :bumps
  has_many :listens
  
  has_attached_file :image, :styles => {:thumb => ["300x200#"]}
  
  def update_listens
    lastfmXML = Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid=#{self.mbid}&api_key=#{ENV['LASTFM_API_KEY']}"))
    self.listens.push(Listen.new(:count => lastfmXML.css("listeners").first.content))
  end
end
