class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :check_setup!, only: [:index]
  
  def index
    if user_signed_in?
      redirect_to dashboard_path
    end
  end
end
