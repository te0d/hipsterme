desc 'tasks used by heroku scheduler'
task :update_listens => :environment do
  Band.includes(:listens).each do |band|
    band.update_listens
    
    current_listen = band.listens.last
    previous_listen = band.listens[-2]
    initial_listen = band.listens.first
    
    if current_listen.count != previous_listen.count
      average_rate = (current_listen.count - initial_listen.count)/(current_listen.created_at - initial_listen.created_at)
      current_rate = (current_listen.count - previous_listen.count)/(current_listen.created_at - previous_listen.created_at)
      percent_change = (current_rate - average_rate)/average_rate
      
      band.users.each do |user|
        bump = user.bumps.where(:band_id => band.id, :unbumped_at => nil).first
        unless bump.nil?
          bump.cred_value += percent_change / 100 * bump.cred_value
          bump.save
        end
      end
    end
  end
end

desc 'for periodic updating of band info from lastfm'
task :update_band_info => :environment do
  Band.all.each do |band|
    lastfmXML = Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid=#{band.mbid}&api_key=#{ENV['LASTFM_API_KEY']}"))
    lastfmXML.css("similar").remove
    
    band.lastfm_desc = lastfmXML.css("summary").first.content
    band.save
  end
end
