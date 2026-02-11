class PackingList < ApplicationRecord
  belongs_to :user

  # Store JSON data
  serialize :destinations, coder: JSON
  serialize :traveler_info, coder: JSON
  serialize :generated_list, coder: JSON

  validates :destinations, presence: true
  validates :traveler_info, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc).limit(10) }

  def title
    if destinations.is_a?(Array) && destinations.any?
      destination_names = destinations.map { |d| d["name"] || d["location"] }.compact
      destination_names.join(", ").truncate(50)
    else
      "Packing List ##{id}"
    end
  end

  def total_items_count
    return 0 unless generated_list.is_a?(Hash)
    
    count = 0
    generated_list.each do |_category, items|
      count += items.size if items.is_a?(Array)
    end
    count
  end
end
