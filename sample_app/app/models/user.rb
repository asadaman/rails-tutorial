class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness:{ case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.convert_string_to_digest(remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token) if remember_digest.present?
  end

  def forget
    update_attribute(:remember_digest, nil)
  end


  class << self
    private

    def cost
      ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    end

    public

    def convert_string_to_digest(original_string)
      BCrypt::Password.create(original_string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
