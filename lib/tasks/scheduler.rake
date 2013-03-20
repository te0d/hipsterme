desc 'tasks used by heroku scheduler'
task :update_listens => :environment do
  Band.all.each do |band|
    band.update_listens
  end
end
