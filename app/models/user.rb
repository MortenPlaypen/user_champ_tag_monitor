class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reports

	def get_mailboxes()
		auth = {:password => "X", :username => self.helpscout_token}
		response = HTTParty.get(URI.encode("https://api.helpscout.net/v1/mailboxes.json"), :basic_auth => auth)
		ret_array=[]
		response["items"].each do |item|
			item_array = []
			item_array.push item["name"]
			item_array.push item["id"]
			ret_array.push(item_array)
		end
		return ret_array
	end
end
