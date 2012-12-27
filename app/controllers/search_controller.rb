class SearchController < ApplicationController
  require 'open-uri'
  
  def index
  end
  
  def results
    @query = CGI.escape(params[:query])
    
    brainzResults = Nokogiri::XML(open("http://www.musicbrainz.org/ws/2/artist/?query=artist:#{@query}"))
    @artists = brainzResults.css("artist")
  end
end
