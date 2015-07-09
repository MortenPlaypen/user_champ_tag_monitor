class DashboardsController < ApplicationController
	before_filter :authenticate_user!
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

	def hello
		render "index" #text: "hello, world!"
	end
end

