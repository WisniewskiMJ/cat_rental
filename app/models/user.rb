# frozen_string_literal: true

class User < ApplicationRecord
  attr_reader :password

  before_validation :ensure_session_token
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats,
           primary_key: :id,
           class_name: :Cat,
           dependent: :destroy

  has_many :requests,
           primary_key: :id,
           class_name: :CatRentalRequest,
           dependent: :destroy

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return user if user&.is_password?(password)

    nil
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token
    self.session_token = User.generate_session_token
    save
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
end
