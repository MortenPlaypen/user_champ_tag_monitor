desc "This task is called by the Heroku scheduler add-on"
task :weekly_reports => :environment do
	
  puts "Sending..."
  if Rails.env == 'production' then SendReport.email(3,false)
  else SendReport.email(31,false)
  end
end