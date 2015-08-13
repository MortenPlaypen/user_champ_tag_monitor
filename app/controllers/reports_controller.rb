class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@report=Report.new
  	@reports = Report.all #(:order => 'created_at DESC')
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
    test = true
  	SendReport.email(id,test)
    respond_to do |format|
      format.js {render :nothing => true, :status => 200}
      format.html
    end
  end

  def delete
    id = params[:delete_id]
    report=Report.find(id)
    report.destroy
    redirect_to :root
  end

  def status
    id = params[:status_id]
    report=Report.find(id)
    #binding.pry
    if report.active == nil or report.active == false then
      report.active = true 
      #binding.pry
    else
      report.active = false
    end
    report.save
    redirect_to :root
  end

  private
  def permit_params
    params.require(:report).permit(:tag, :recipient_email, :mailbox_hsid, :send_time)
  end

end
