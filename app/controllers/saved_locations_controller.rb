class SavedLocationsController < ApplicationController
  before_action :set_saved_location, only: [:show, :edit, :update, :destroy]

  def index
    @saved_locations = current_user.saved_locations.order(:name)
  end

  def show
  end

  def new
    @saved_location = current_user.saved_locations.new
  end

  def edit
  end

  def create
    @saved_location = current_user.saved_locations.new(saved_location_params)

    if @saved_location.save
      flash[:notice] = "Location saved!"
      redirect_to saved_locations_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @saved_location.update(saved_location_params)
      flash[:notice] = "Location updated!"
      redirect_to saved_locations_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @saved_location.destroy
    flash[:notice] = "Location deleted."
    redirect_to saved_locations_path
  end

  private

  def set_saved_location
    @saved_location = current_user.saved_locations.find(params[:id])
  end

  def saved_location_params
    params.require(:saved_location).permit(:name, :address, default_activities: [])
  end
end
