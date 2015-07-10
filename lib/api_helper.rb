require 'httparty'

module APIHelper
  class HelpScoutClient
    include HTTParty

    # setting base uri for API calls
    base_uri 'https://api.helpscout.net/v1'

    def initialize(api_token)
      @auth = {username: api_token, password: 'X'}
    end

    # return mailboxes list on HelpScout
    def mailboxes
      HelpScoutClient.get('/mailboxes.json', basic_auth: @auth).parsed_response['items']
    end

    def search_conversations_within_n_days(mailbox_id, days_num = 90)
      # getting conversations from special mailbox modified from days_num to now
      search_since_date = (DateTime .now - days_num).strftime('%FT%TZ')
      # getting collection of items from response
      HelpScoutClient.get("/mailboxes/#{mailbox_id}/conversations.json?query=(modifiedAt:[#{search_since_date}%20TO%20*])", basic_auth: @auth).parsed_response['items']
    end

    def conversation(id)
      HelpScoutClient.get("/conversations/#{id}.json", basic_auth: @auth).parsed_response['item']
    end

  end

end