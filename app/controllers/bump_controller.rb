class BumpController < ApplicationController
  require 'open-uri'
  
  before_filter :authenticate_user!
  
  def index
    @user = current_user
    @bands = current_user.bands.reverse
  end

  def new
    # get the unique musicbrainz to grab data from musicbrainz and lastfm
    band_mbid = params[:mbid]
    
    # check to see if the band exists in the db, if not add it
    if Band.where(:mbid => band_mbid).empty?
      
      band = Band.new
      band.mbid = band_mbid
    
      # grab band information from musicbrainz and lastfm
      brainzXML = Nokogiri::XML(open("http://www.musicbrainz.org/ws/2/artist/#{band_mbid}"))
      lastfmXML = Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid=#{band_mbid}&api_key=#{ENV['LASTFM_API_KEY']}"))
      
      # parse out band information
      lastfmXML.css("similar").remove
      band.name = brainzXML.css("name").first.content
      for image in lastfmXML.css("image")
        image_url = image.content if image.attr('size') == 'extralarge'
      end
      band.image = open(image_url) unless image_url.nil?
      band.listens.push(Listen.new(:count => lastfmXML.css("listeners").first.content))
      band.creator_id = current_user.id
      
      band.save
      
    else
    
      band = Band.where(:mbid => band_mbid).first
      
    end
    
    current_user.bands.push(band) unless current_user.bands.include?(band)
    
    redirect_to :action => 'index'
  end

  def destroy
    @band = Band.find(params[:id])
    current_user.bands.delete(@band)
    
    redirect_to :action => 'index'
  end
end
