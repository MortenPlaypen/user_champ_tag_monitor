class UserMailer
	def new_user
		mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
		recipient_email = report.user.email
		message["subject"] = "New User Signed Up For TagMonitor"
	    message["to"] =  
	    	[{
	    	"type"=>"to",
            "email"=>morten@playpenlabs.com
            }]
	    
	    message["from_email"] = "morten@playpenlabs.com"
	    body = ""
	    mandrill.messages.send true
	end
end