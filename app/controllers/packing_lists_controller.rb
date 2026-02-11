class PackingListsController < ApplicationController
  before_action :set_packing_list, only: [:show, :destroy, :regenerate]

  def index
    @packing_lists = current_user.packing_lists.order(created_at: :desc)
  end

  def show
  end

  def new
    @packing_list = current_user.packing_lists.new
    @saved_locations = current_user.saved_locations
    @custom_items = current_user.custom_items.always_pack
    @activities = current_user.activities
  end

  def create
    service = PackingListGenerator.new(current_user, packing_list_params)
    result = service.generate

    if result[:success]
      @packing_list = result[:packing_list]
      flash[:notice] = "Packing list generated successfully!"
      redirect_to @packing_list
    else
      flash[:alert] = result[:error]
      redirect_to new_packing_list_path
    end
  end

  def destroy
    @packing_list.destroy
    flash[:notice] = "Packing list deleted."
    redirect_to packing_lists_path
  end

  def regenerate
    service = PackingListGenerator.new(current_user, {
      destinations: @packing_list.destinations,
      traveler_info: @packing_list.traveler_info,
      notes: @packing_list.notes
    })
    
    result = service.regenerate(@packing_list)

    if result[:success]
      flash[:notice] = "Packing list regenerated!"
    else
      flash[:alert] = result[:error]
    end
    
    redirect_to @packing_list
  end

  private

  def set_packing_list
    @packing_list = current_user.packing_lists.find(params[:id])
  end

  def packing_list_params
    params.require(:packing_list).permit(
      :notes,
      :laundry_available,
      :luggage_volume,
      :luggage_name,
      traveler_info: [:gender, :age, :shirt_size, :pants_size, :shoe_size, :sleepwear],
      destinations: [:location, :start_date, :end_date],
      activities: []
    )
  end
end
