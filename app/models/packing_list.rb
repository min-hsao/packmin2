class PackingList < ApplicationRecord
  belongs_to :user
  
  STATUSES = %w[draft generating complete error].freeze
  
  validates :status, inclusion: { in: STATUSES }
  
  before_create :set_title
  
  scope :recent, -> { order(created_at: :desc) }
  scope :complete, -> { where(status: 'complete') }
  
  def destination_names
    destinations.map { |d| d['location'] }.join(', ')
  end
  
  def total_days
    destinations.sum { |d| 
      start_date = Date.parse(d['start_date']) rescue nil
      end_date = Date.parse(d['end_date']) rescue nil
      next 0 unless start_date && end_date
      (end_date - start_date).to_i + 1
    }
  end
  
  def parsed_list
    return {} if generated_list.blank?
    generated_list.is_a?(String) ? JSON.parse(generated_list) : generated_list
  rescue JSON::ParserError
    {}
  end
  
  private
  
  def set_title
    return if title.present?
    self.title = if destinations.any?
      "#{destination_names} - #{destinations.first['start_date']}"
    else
      "Packing List #{created_at&.strftime('%Y-%m-%d') || 'New'}"
    end
  end
end
