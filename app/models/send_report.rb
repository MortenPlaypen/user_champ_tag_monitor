require 'mandrill'
require 'httparty'

class SendReport
	include HTTParty

	def self.email(report_id)
		mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    	report=Report.find(report_id)
    	data=get_conversations(report)
    	message = {}
	    message["subject"] = "Your weekly report"
        message["html"] = data
	    message["to"] =  [{
	    	"type"=>"to",
            "email"=>report.recipient_email
            }]
	    message["from_email"] = "morten@playpenlabs.com"
	    mandrill.messages.send message, true
	end

	def self.get_conversations(report)
		date = DateTime.now - 30
		auth = {:password => "X", :username => report.user.helpscout_token}
		response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes/#{report.mailbox_hsid}/conversations.json?tag=#{report.tag}&modifiedSince=#{date}"), :basic_auth => auth)
		ret_html = ""
		previous_week = []
		current_week = []
		response["items"].each do |item|
			if item["createdAt"] < DateTime.now - 10
				previous_week.push(item)
				#binding.pry
			else
				current_week.push(item)
				#binding.pry
			end
		#previous_week = previous_week[0]
		end
		#response = response.to_hash
		#binding.pry
		ret_html = response["items"].count.to_s + " emails tagged with " + "'" + report.tag.to_s + "'" + " this week (" + previous_week.count.to_s + " last week)" + "</br></br>"
		conv_count = 1
		response["items"].each do |item|
			conversation_id = item["id"]
			thread_response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/conversations/#{conversation_id}.json"), :basic_auth => auth)
			ret_html += "Email " + conv_count.to_s
			ret_html+= "</br>"
			ret_html+= "-----------------------------------------"
			ret_html+= "</br>"
			ret_html += "'" + "#{thread_response['item']['subject']}" + "'"
			ret_html+= "</br>"
			ret_html += "#{thread_response['item']['threads'].last['body']}"
			ret_html+= "</br>"
			ret_html+= "-----------------------------------------"
			ret_html += "</br><br>"
			conv_count = conv_count + 1
		end
		return ret_html
	end
end
