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

  def get_reports
  	return_reports=["Test Report"]
  end

  # GET /send_test
  def send_test
  	id = params[:report_id]
  	SendReport.email(id)
    render status: :ok
  end

  def delete
    id = params[:delete_id]
    #puts "hej"
    report=Report.find(id)
    report.destroy
    redirect_to :root
  end

  private
  def permit_params
    params.require(:report).permit(:tag, :recipient_email, :mailbox_hsid)
  end

end
