class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]
  skip_before_action :check_setup!, only: [:create, :failure]

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_from_oauth(auth)
    
    session[:user_id] = user.id
    
    if user.setup_completed?
      flash[:notice] = "Welcome back, #{user.display_name}!"
      redirect_to root_path
    else
      flash[:notice] = "Welcome! Let's set up your account."
      redirect_to setup_path
    end
  rescue StandardError => e
    Rails.logger.error "OAuth error: #{e.message}"
    flash[:alert] = "Authentication failed. Please try again."
    redirect_to root_path
  end

  def failure
    flash[:alert] = "Authentication failed: #{params[:message]}"
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    flash[:notice] = "You have been signed out."
    redirect_to root_path
  end
end
