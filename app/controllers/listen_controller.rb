class ListenController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @user = current_user
  end

  def new
    band_mbid = params[:mbid]
    brainzResults = Nokogiri::XML(open("http://www.musicbrainz.org/ws/2/artist/#{band_mbid}"))
    band_name = brainzResults.css("name").first.content
    band = Band.where(:mbid => band_mbid, :name => band_name).first_or_create
    current_user.bands.push(band)
  end

  def destroy
  end
end
