class SetupController < ApplicationController
  skip_before_action :require_setup

  def show
    if current_user.setup_completed?
      redirect_to root_path
      return
    end
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(setup_params)
      @user.update!(setup_completed: true)
      flash[:notice] = "Setup complete! Welcome to PackMin."
      redirect_to root_path
    else
      flash.now[:alert] = "Please fix the errors below."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def setup_params
    params.require(:user).permit(:ai_provider, :ai_api_key, :openweather_api_key)
  end
end
