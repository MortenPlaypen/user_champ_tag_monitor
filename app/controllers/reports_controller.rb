class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@report=Report.new
  	@reports = Report.all
  end

  def create
  	@report=current_user.reports.create(permit_params)
  	redirect_to :root
  end

  def get_reports()
  	return_reports=["Test Report"]
  end

  # GET /show_message
  def show_message()
  	id = params[:id]
  	SendReport.email(id)
  	render js: "alert('It has been sent!');"
  	#test_param=recipient_email
  	
  	#binding.pry
    #if id==nil then
    #	render js: "alert('It is empty');"
    #else
    #	render js: "alert('It is not empty');"
    #end

    #render js: "alert('simple output');"
	#render js: "alert('params[:user_id]'');"
    #params[:user_id]
  end

  private
  def permit_params
    params.require(:report).permit(:tag, :recipient_email, :mailbox_hsid)
  end

end
