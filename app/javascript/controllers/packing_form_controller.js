import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["destinations"]
  
  addDestination() {
    const template = `
      <div class="destination-entry bg-gray-50 rounded-lg p-4 mb-3 relative">
        <button type="button" 
                onclick="this.parentElement.remove()"
                class="absolute top-2 right-2 text-gray-400 hover:text-red-500">
          ✕
        </button>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div class="sm:col-span-3">
            <label class="block text-sm font-medium text-gray-700 mb-1">Location</label>
            <input type="text" name="packing_list[destinations][][location]" 
                   class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                   placeholder="e.g., Rome, Italy" required>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Start Date</label>
            <input type="date" name="packing_list[destinations][][start_date]" 
                   class="w-full px-3 py-2 border border-gray-300 rounded-lg" required>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">End Date</label>
            <input type="date" name="packing_list[destinations][][end_date]" 
                   class="w-full px-3 py-2 border border-gray-300 rounded-lg" required>
          </div>
        </div>
      </div>
    `
    this.destinationsTarget.insertAdjacentHTML('beforeend', template)
  }
}
