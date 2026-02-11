class SavedLocationsController < ApplicationController
  before_action :set_saved_location, only: [:show, :edit, :update, :destroy]
  
  def index
    @saved_locations = current_user.saved_locations.recent
  end
  
  def new
    @saved_location = current_user.saved_locations.build
  end
  
  def create
    @saved_location = current_user.saved_locations.build(saved_location_params)
    if @saved_location.save
      redirect_to saved_locations_path, notice: "Location saved!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit; end
  
  def update
    if @saved_location.update(saved_location_params)
      redirect_to saved_locations_path, notice: "Location updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @saved_location.destroy
    redirect_to saved_locations_path, notice: "Location deleted."
  end
  
  private
  
  def set_saved_location
    @saved_location = current_user.saved_locations.find(params[:id])
  end
  
  def saved_location_params
    params.require(:saved_location).permit(:name, :address, :default_activities, :favorite)
  end
end
