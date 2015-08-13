desc "This task is called by the Heroku scheduler add-on"
task :weekly_reports => :environment do
  puts "Doing the thing..."
end