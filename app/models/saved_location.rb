class SavedLocation < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :address, presence: true

  # Store default activities as JSON array
  serialize :default_activities, coder: JSON

  def display_name
    "#{name} (#{address.truncate(30)})"
  end
end
