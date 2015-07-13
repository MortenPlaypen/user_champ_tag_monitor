require 'mandrill'
require 'httparty'

class SendReport
	include HTTParty

	def self.email(report_id)
		mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    	report=Report.find(report_id)
    	data=get_conversations(report)
    	message = {}
	    message["subject"] = "Test"
        message["html"] = data
	    message["to"] =  [
            {
                "email": report.recipient_email,
                "type": "to"
            }
        ]
	    message["from_email"] = "morten@playpenlabs.com"
	    #binding.pry
	    mandrill.messages.send message, true
	end

	def self.get_conversations(report)
		auth = {:password => "X", :username => report.user.helpscout_token}
		response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes/#{report.mailbox_hsid}/conversations.json?tag=#{report.tag}"), :basic_auth => auth)
		ret_html = ""
		response["items"].each do |item|
			conversation_id = item["id"]
			thread_response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/conversations/#{conversation_id}.json"), :basic_auth => auth)
			ret_html += "#{thread_response['item']['subject']}"
			ret_html+= "</br>"
			ret_html += "#{thread_response['item']['threads'].last['body']}"
			ret_html += "</br>"
		end
		return ret_html
	end
end
