class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_setup!, if: :user_signed_in?
  
  private
  
  def check_setup!
    return if devise_controller?
    return if controller_name == 'setup'
    return if current_user.setup_complete?
    
    redirect_to setup_path, notice: "Please complete your setup to continue."
  end
  
  def after_sign_in_path_for(resource)
    if resource.setup_complete?
      dashboard_path
    else
      setup_path
    end
  end
end
