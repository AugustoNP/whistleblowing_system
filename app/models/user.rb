class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # UPDATED ENUM: visitor(0), rh(1), diligence(2), admin(3)
  enum :role, { visitor: 0, rh: 1, diligence: 2, admin: 3 }, default: :visitor

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password, allow_nil: true, length: { minimum: 8 }

  # Helper methods for cleaner controller logic
  def can_edit_observations?
    admin? || rh?
  end

  def can_manage_diligence?
    admin? || diligence?
  end

  def generate_password_reset_token
    update!(
      password_reset_token: SecureRandom.urlsafe_base64,
      password_reset_sent_at: Time.current
    )
  end

  def password_reset_expired?
    password_reset_sent_at < 15.minutes.ago
  end
end