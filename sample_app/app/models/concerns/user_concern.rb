module UserConcern
  extend ActiveSupport::Concern

  def convert_string_to_digest(original_string)
    BCrypt::Password.create(original_string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  private

  def cost
    ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  end
end
