desc "This task is called by the Heroku scheduler add-on"
task :weekly_reports => :environment do
	Report.all.each do |report|
		id = report.id
    	test = false
    	if report.active == true
    		binding.pry
			SendReport.email(id,test)
		end
	end
end