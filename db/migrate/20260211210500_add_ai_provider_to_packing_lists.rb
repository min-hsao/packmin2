class AddAiProviderToPackingLists < ActiveRecord::Migration[7.1]
  def change
    add_column :packing_lists, :ai_provider, :string
  end
end
