desc "This task is called by the Heroku scheduler add-on"
task :weekly_reports => :environment do
	if Time.now.wday == 1
		Report.all.each do |report|
			id = report.id
	    	test = false
	    	if report.active == true
				SendReport.email(id,test)
			end
		end
	end
end