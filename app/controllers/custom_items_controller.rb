class CustomItemsController < ApplicationController
  before_action :set_custom_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @custom_items = current_user.custom_items.order(:category, :name)
  end
  
  def new
    @custom_item = current_user.custom_items.build
  end
  
  def create
    @custom_item = current_user.custom_items.build(custom_item_params)
    if @custom_item.save
      redirect_to custom_items_path, notice: "Item saved!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit; end
  
  def update
    if @custom_item.update(custom_item_params)
      redirect_to custom_items_path, notice: "Item updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @custom_item.destroy
    redirect_to custom_items_path, notice: "Item deleted."
  end
  
  private
  
  def set_custom_item
    @custom_item = current_user.custom_items.find(params[:id])
  end
  
  def custom_item_params
    params.require(:custom_item).permit(:name, :category, :volume_liters, :always_pack, :notes)
  end
end
