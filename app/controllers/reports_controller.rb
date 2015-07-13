class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@report=Report.new
  end

  def create
  	@report=current_user.reports.create(permit_params)
  	redirect_to :root
  end

  private
  def permit_params
    params.require(:report).permit(:tag, :recipient_email)
  end

end
