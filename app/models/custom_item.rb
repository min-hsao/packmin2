class CustomItem < ApplicationRecord
  belongs_to :user
  
  CATEGORIES = %w[clothing toiletries electronics documents medical sports accessories other].freeze
  
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :category, inclusion: { in: CATEGORIES, allow_blank: true }
  validates :volume_liters, numericality: { greater_than: 0 }, allow_nil: true
  
  scope :always_packed, -> { where(always_pack: true) }
  scope :by_category, ->(cat) { where(category: cat) }
end
