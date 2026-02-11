class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :require_setup, unless: :skip_setup_check?

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Please sign in to continue."
      redirect_to root_path
    end
  end

  def require_setup
    if logged_in? && !current_user.setup_completed?
      redirect_to setup_path unless request.path == setup_path
    end
  end

  def skip_setup_check?
    controller_name.in?(%w[sessions]) || action_name == "show" && controller_name == "dashboard" && !logged_in?
  end
end
