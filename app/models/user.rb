class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :valid_token, on: :create
 
  def valid_token
  	auth = {:password => "X", :username => self.helpscout_token}
	response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes.json"), :basic_auth => auth)
    if response["code"]="401"
      errors.add(:helpscout_token, "is not valid")
    end
  end


  has_many :reports

	def get_mailboxes
		auth = {:password => "X", :username => self.helpscout_token}
		response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes.json"), :basic_auth => auth)
		
		auth_fail = {:password => "X", :username => "1234567890"}
		response_fail = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes.json"), :basic_auth => auth_fail)

		ret_array=[]
		response["items"].each do |item|
			item_array = []
			item_array.push item["name"]
			item_array.push item["id"]
			ret_array.push(item_array)
		end
		return ret_array
	end

	def get_tags
		auth = {:password => "X", :username => self.helpscout_token}
		response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/tags.json"), :basic_auth => auth)
		ret_array=[]
		response["items"].each do |item|
			item_array = []
			item_array.push item["tag"]
			item_array.push item["tag"]
			ret_array.push(item_array)
		end
		return ret_array
	end

	def get_mailbox_name(mailbox_hsid)
		auth = {:password => "X", :username => self.helpscout_token}
		response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes.json"), :basic_auth => auth)
		mailbox_name=""
		response["items"].each do |item|
			id_string = item["id"].to_s
			if id_string == mailbox_hsid
				mailbox_name = item["name"]
			end
		end
		return mailbox_name
	end
end
