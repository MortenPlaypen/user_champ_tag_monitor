class DashboardsController < ApplicationController
	#include APIHelper
	before_filter :authenticate_user!
	#before_action :check_api_setting
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

	def hello
		render "index" #text: "hello, world!"
	end

end