class CustomItemsController < ApplicationController
  before_action :set_custom_item, only: [:show, :edit, :update, :destroy]

  def index
    @custom_items = current_user.custom_items.order(:category, :name)
  end

  def show
  end

  def new
    @custom_item = current_user.custom_items.new
  end

  def edit
  end

  def create
    @custom_item = current_user.custom_items.new(custom_item_params)

    if @custom_item.save
      flash[:notice] = "Item saved!"
      redirect_to custom_items_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @custom_item.update(custom_item_params)
      flash[:notice] = "Item updated!"
      redirect_to custom_items_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @custom_item.destroy
    flash[:notice] = "Item deleted."
    redirect_to custom_items_path
  end

  private

  def set_custom_item
    @custom_item = current_user.custom_items.find(params[:id])
  end

  def custom_item_params
    params.require(:custom_item).permit(:name, :category, :volume_liters, :always_pack)
  end
end
