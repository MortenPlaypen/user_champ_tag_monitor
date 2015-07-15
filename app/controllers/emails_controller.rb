class EmailsController < ApplicationController

	def index
  		report_id = params[:id]
  		@report_id = report_id
  		report=Report.find(report_id)
    	@email_message = SendReport.get_conversations(report)
    	#binding.pry
  		#render js: "alert('It has been sent!');"
  	end
end
