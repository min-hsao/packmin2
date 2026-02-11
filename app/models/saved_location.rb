class SavedLocation < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :address, presence: true
  
  scope :favorites, -> { where(favorite: true) }
  scope :recent, -> { order(updated_at: :desc) }
end
