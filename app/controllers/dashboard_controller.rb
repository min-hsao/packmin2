class DashboardController < ApplicationController
  skip_before_action :require_login, only: [:show]
  skip_before_action :require_setup, only: [:show]

  def show
    if logged_in?
      @recent_lists = current_user.packing_lists.recent
      @saved_locations_count = current_user.saved_locations.count
      @custom_items_count = current_user.custom_items.count
    end
  end
end
