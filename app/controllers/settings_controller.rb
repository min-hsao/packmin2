class SettingsController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(settings_params)
      flash[:notice] = "Settings updated successfully!"
      redirect_to settings_path
    else
      flash.now[:alert] = "Please fix the errors below."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.require(:user).permit(:ai_provider, :ai_api_key, :openweather_api_key)
  end
end
