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
  def show_message
  	puts "Yo!"
    render js: "alert('simple output');"
  end

  private
  def permit_params
    params.require(:report).permit(:tag, :recipient_email, :mailbox_hsid)
  end

end
