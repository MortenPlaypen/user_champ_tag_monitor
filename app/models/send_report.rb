require 'mandrill'
require 'httparty'

class SendReport
	include HTTParty

	def self.email(report_id,test)
		mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    	report=Report.find(report_id)
    	data=get_conversations(report)

    	message = {}
	    
        #message["html"] = data
        if test == true then
        	recipient_email = report.user.email
        	message["subject"] = "PREVIEW: Your weekly report"
        else
        	recipient_email = report.recipient_email
        	message["subject"] = "Your weekly report"
        end
	    message["to"] =  [{
	    	"type"=>"to",
            "email"=>recipient_email
            }]
	    message["from_email"] = "morten@playpenlabs.com"
	    body = ""
	    data[:emails].each do |email|
	    	body_temp = "<div>Sent: #{email[:email_date].html_safe}</div><div>Subject: #{email[:email_subject].html_safe}</div><div>#{email[:email_body].html_safe}</div>"
	    	if body == "" then
	    		body = body_temp
	    	else
	    		body = body + "<br><br>" + body_temp
	    	end	
		end
	    template_name = "tagmonitor_weekly"
	    template_content = []
	    report_summary = "Between #{data[:start_day]} and #{data[:end_day]} there #{if data[:this_week]>1 then "were" else "was" end} #{data[:this_week]} #{if data[:this_week]>1 then "emails" else "email" end} tagged with '#{data[:tag]}' (#{data[:last_week]} the week before)"
	    message["global_merge_vars"]  = [{"name"=>"REPORT_SUMMARY", "content"=>report_summary},{"name"=>"REPORT_EMAILS", "content"=>body}]

	    mandrill.messages.send_template template_name, template_content, message, true
	end

	def self.get_conversations(report)
		date = (Time.now.utc - 14.days).strftime("%Y-%m-%dT%H:%M:%SZ")
		auth = {:password => "X", :username => report.user.helpscout_token}
		api_url = "https://api.helpscout.net/v1/mailboxes/#{report.mailbox_hsid}/conversations.json?tag=#{report.tag}&modifiedSince=#{date}"
		response = HTTParty.get(URI.encode(api_url), :basic_auth => auth)
		ret_hash = {}
		emails_arr = []
		response["items"].each do |item|
			if item["createdAt"] > DateTime.now - 7
			
				email_hash = {}
				conversation_id = item["id"]
				thread_response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/conversations/#{conversation_id}.json"), :basic_auth => auth)
				email_hash = { :email_subject => thread_response['item']['subject'], :email_body => thread_response['item']['threads'].last['body'], :email_date => thread_response['item']['createdAt'].to_time.strftime("%m-%d-%Y-%H:%M") }
				emails_arr.push(email_hash)
			end
		end
		this_week = emails_arr.count
		last_week = response["items"].count - emails_arr.count
		end_day = (Time.now.utc).strftime("%m/%d")
		start_day = (Time.now.utc - 7.days).strftime("%m/%d")
		ret_hash = { :last_week => last_week, :this_week => this_week, :tag =>report.tag, :end_day => end_day, :start_day => start_day, :emails => emails_arr }
		return ret_hash
	end
end
