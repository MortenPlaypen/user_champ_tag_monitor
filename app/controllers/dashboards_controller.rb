class DashboardsController < ApplicationController
	include APIHelper
	before_filter :authenticate_user!
	before_action :check_api_setting
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

	#def hello
	#	render "index" #text: "hello, world!"
	#end

	def index
	    # API for what service we should use
	    current_service = current_user.setting.source

	    # getting tags for certain user with certain settings (zendesk or helpscout)
	    #need to fix how tags are retrieved and saved
	    @tags = Tag.joins(:tickets).where(%{ "tags"."source" = '#{current_service}' AND "tickets"."user_id" = #{current_user.id} }).group("tags.id").order("tickets.count DESC")
	    @tag_count = @tags.to_a.count
	    @ticket_count = current_user.tickets.count
	    @tagged_percentage = (@tag_count.to_f / @ticket_count.to_f * 100).round

  	end

  	# show information about tickets which have certain tag
  	def show_tickets_info
	    result = @zendesk_client.search(query: "type:ticket created>#{Date.today - params[:within_days_num].to_i} tags:#{params[:tag]}")
	    tickets = []
	    info_hash = {
	        target_tag: params[:tag],
	        received_in_days_num: params[:within_days_num]
	    }
	    result.each do |ticket|
	      ticket = {
	          subject: ticket[:subject],
	          description: ticket[:description]
	      }
	      tickets << ticket
	    end
	    info_hash[:tickets] = tickets
	    render json: info_hash
  	end

  private
  # check of user has setting (zendesk or helpscout)
  def check_api_setting
    redirect_to :back unless current_user.complete_settings?
  end

  # creatig zendesk client for API calls
  def create_zendesk_client
    @zendesk_client = ZendeskClient.instance(current_user.setting)
  end

  def ticket_has_tags?(ticket)
    # in HelpScout API if conversation has no tags then tags=[]
    # and its class is nil (not Array) so i added this check
    if ticket['tags'].nil?
      false
    else
      ticket['tags'].empty? ? false : true
    end
  end

  def assign_tag_to_ticket(ticket_obj, tag_keyword = 'not tagged', service_name)
    # check if tag already exists in db
    searched_tag = Tag.where(keyword: tag_keyword, source: service_name).first
    unless searched_tag.blank?
      TagTicket.create(ticket_id: ticket_obj.id, tag_id: searched_tag.id)
    else
      ticket_obj.tags.create(keyword: tag_keyword, source: service_name)
    end
  end
end