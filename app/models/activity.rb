class Activity < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true, uniqueness: { scope: :user_id }
  
  def items_list
    return [] if default_items.blank?
    JSON.parse(default_items) rescue []
  end
  
  def items_list=(items)
    self.default_items = items.to_json
  end
end
