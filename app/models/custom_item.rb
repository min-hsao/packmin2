class CustomItem < ApplicationRecord
  belongs_to :user

  CATEGORIES = %w[
    clothing
    toiletries
    electronics
    documents
    medications
    accessories
    miscellaneous
  ].freeze

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :volume_liters, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :always_pack, -> { where(always_pack: true) }
  scope :by_category, ->(cat) { where(category: cat) }
end
