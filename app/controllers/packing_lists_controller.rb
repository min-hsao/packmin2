class PackingListsController < ApplicationController
  before_action :set_packing_list, only: [:show, :destroy, :regenerate]
  
  def index
    @packing_lists = current_user.packing_lists.recent.page(params[:page]).per(10)
  end
  
  def new
    @packing_list = current_user.packing_lists.build
    @saved_locations = current_user.saved_locations.recent
    @activities = current_user.activities
    @custom_items = current_user.custom_items.always_packed
  end
  
  def create
    @packing_list = current_user.packing_lists.build(packing_list_params)
    @packing_list.status = 'generating'
    
    if @packing_list.save
      GeneratePackingListJob.perform_later(@packing_list.id)
      redirect_to @packing_list, notice: "Generating your packing list..."
    else
      @saved_locations = current_user.saved_locations.recent
      @activities = current_user.activities
      @custom_items = current_user.custom_items.always_packed
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    respond_to do |format|
      format.html
      format.turbo_stream if @packing_list.status == 'generating'
    end
  end
  
  def destroy
    @packing_list.destroy
    redirect_to packing_lists_path, notice: "Packing list deleted."
  end
  
  def regenerate
    @packing_list.update(status: 'generating', generated_list: {}, raw_response: nil)
    GeneratePackingListJob.perform_later(@packing_list.id)
    redirect_to @packing_list, notice: "Regenerating your packing list..."
  end
  
  private
  
  def set_packing_list
    @packing_list = current_user.packing_lists.find(params[:id])
  end
  
  def packing_list_params
    params.require(:packing_list).permit(
      :ai_provider,
      :luggage_volume,
      :luggage_name,
      :activities,
      :laundry_available,
      :additional_notes,
      traveler_info: [:gender, :age, :clothing_size, :shoe_size, :sleepwear],
      destinations: [:location, :start_date, :end_date]
    )
  end
end
