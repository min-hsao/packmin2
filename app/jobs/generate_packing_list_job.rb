class GeneratePackingListJob < ApplicationJob
  queue_as :default
  
  def perform(packing_list_id)
    packing_list = PackingList.find(packing_list_id)
    return if packing_list.status == 'complete'
    
    generator = PackingListGenerator.new(packing_list)
    generator.generate
    
    # Broadcast update via Turbo
    Turbo::StreamsChannel.broadcast_replace_to(
      "packing_list_#{packing_list.id}",
      target: "packing_list_content",
      partial: "packing_lists/content",
      locals: { packing_list: packing_list }
    )
  rescue => e
    Rails.logger.error "GeneratePackingListJob failed: #{e.message}"
    packing_list.update(status: 'error') if packing_list
    raise
  end
end
