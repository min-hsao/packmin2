class DashboardController < ApplicationController
  def index
    @recent_lists = current_user.packing_lists.recent.limit(5)
    @saved_locations = current_user.saved_locations.favorites.limit(5)
    @custom_items_count = current_user.custom_items.count
    @activities_count = current_user.activities.count
  end
end
