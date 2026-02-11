class Activity < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  # Store associated items as JSON array
  serialize :associated_items, coder: JSON

  # Preset activities that users can choose from
  PRESETS = [
    "Beach/Swimming",
    "Hiking",
    "Business meetings",
    "Formal dinner",
    "Sightseeing",
    "Photography",
    "Working out",
    "Running",
    "Skiing/Snowboarding",
    "Camping",
    "Wedding",
    "Conference"
  ].freeze
end
