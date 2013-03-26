class BumpController < ApplicationController
  require 'open-uri'
  
  before_filter :authenticate_user!
  
  def index
    @user = current_user
    @bumps = @user.bumps.includes(:band).where(:unbumped_at => nil)
  end

  def new
    # get the unique musicbrainz to grab data from musicbrainz and lastfm
    band_mbid = params[:mbid]
    invested_cred = params[:invested_cred].to_i
    
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
    
    if Bump.where(:user_id => current_user.id, :band_id => band.id, :unbumped_at => nil).empty?
      bump = Bump.new
      bump.user_id = current_user.id
      bump.band_id = band.id
      if current_user.available_cred.to_i >= invested_cred
        bump.invested_cred = invested_cred
        bump.cred_value = invested_cred
        current_user.available_cred -= invested_cred
        current_user.save
      end
      bump.save
    end
    
    redirect_to :action => 'index'
  end

  def destroy
    # find bump via url and define unbumped_at
    bump = Bump.find(params[:id])
    bump.unbumped_at = Time.now
    # consider recalculating the cred_value
    bump.save
    
    # take the value attributed to the bump and add to user's available
    user = bump.user
    user.available_cred += bump.cred_value
    user.save
    
    redirect_to :action => 'index'
  end
end
