class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, uniqueness: true, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

  def self.find_by_token(token)
    user = User.find_by_session_token(token)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
