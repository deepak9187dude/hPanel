class AdminLogsController < ApplicationController
  layout 'admin_backend'   
  before_filter :admin_current_user
  
  def jobs_queue
    @job_type = params[:type]
    case @job_type
    when "completed"
      @job_queues = ""
      @job_queue_navigation = "Completed Logs"
    when "action"
      @job_queues = ""
      @job_queue_navigation = "Action Logs"
    when "error"
      @job_queues = ""
      @job_queue_navigation = "Error Logs"
    else
      @job_queues = ""
      @job_queue_navigation = ""
    end
  end
  
  def long_queue
    @long_type = params[:type]
    case @long_type
    when "completed"
      @long_queues = ""
      @long_queue_navigation = "Long Job Queue"
    when "action"
      @long_queues = ""
      @long_queue_navigation = "Long Job Queue"
    when "error"
      @long_queues = ""
      @long_queue_navigation = "Error Logs"
    else
      @long_queues = ""
      @long_queue_navigation = ""
    end    
  end
  
end
