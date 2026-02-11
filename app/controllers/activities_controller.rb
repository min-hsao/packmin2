class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = current_user.activities.order(:name)
  end

  def show
  end

  def new
    @activity = current_user.activities.new
  end

  def edit
  end

  def create
    @activity = current_user.activities.new(activity_params)

    if @activity.save
      flash[:notice] = "Activity saved!"
      redirect_to activities_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @activity.update(activity_params)
      flash[:notice] = "Activity updated!"
      redirect_to activities_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy
    flash[:notice] = "Activity deleted."
    redirect_to activities_path
  end

  private

  def set_activity
    @activity = current_user.activities.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, associated_items: [])
  end
end
