class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  
  def index
    @activities = current_user.activities.order(:name)
  end
  
  def new
    @activity = current_user.activities.build
  end
  
  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      redirect_to activities_path, notice: "Activity preset saved!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit; end
  
  def update
    if @activity.update(activity_params)
      redirect_to activities_path, notice: "Activity updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @activity.destroy
    redirect_to activities_path, notice: "Activity deleted."
  end
  
  private
  
  def set_activity
    @activity = current_user.activities.find(params[:id])
  end
  
  def activity_params
    params.require(:activity).permit(:name, :description, :default_items)
  end
end
