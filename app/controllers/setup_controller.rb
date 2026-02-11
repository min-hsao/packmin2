class SetupController < ApplicationController
  skip_before_action :check_setup!
  
  AI_PROVIDERS = {
    'deepseek' => { name: 'DeepSeek', needs_key: true, description: 'Fast and affordable AI' },
    'openai' => { name: 'OpenAI (GPT-4)', needs_key: true, description: 'Most capable, higher cost' },
    'gemini' => { name: 'Google Gemini', needs_key: true, description: 'Google\'s latest AI' },
    'anthropic' => { name: 'Anthropic Claude', needs_key: true, description: 'Safe and helpful AI' }
  }.freeze
  
  def index
    @ai_providers = AI_PROVIDERS
  end
  
  def update
    if current_user.update(setup_params)
      current_user.update(setup_completed: true)
      redirect_to dashboard_path, notice: "Setup complete! You're ready to create packing lists."
    else
      @ai_providers = AI_PROVIDERS
      flash.now[:alert] = "Please fix the errors below."
      render :index, status: :unprocessable_entity
    end
  end
  
  private
  
  def setup_params
    params.require(:user).permit(
      :ai_provider, 
      :ai_api_key, 
      :openweather_api_key,
      :default_gender,
      :default_age,
      :default_clothing_size,
      :default_shoe_size,
      :default_sleepwear
    )
  end
end
