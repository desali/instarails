class User < ApplicationRecord
	attr_accessor :remember_token

	has_secure_password
	has_one_attached :avatar
	has_many :posts

	validates_presence_of :email, :username
	validates_uniqueness_of :email, :username
	validates :password, length: {minimum: 6, maximum: 30}
	validates_email_format_of :email, message: 'The e-mail format is not correct!'
	validates :username, :password, format: { with: /\A[0-9a-zA-Z_.\-]+\Z/, message: "Only alphanumeric characters, and -_."}
	validates :username, length: {maximum: 30}

	before_create {self.email = email.downcase}
	before_create {self.username = username.downcase}

	class << self
	# Returns the hash digest of the given string.
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

	# Returns a random token.
	def new_token
    SecureRandom.urlsafe_base64
  end

	# Remembers a user in the database for use in persistent sessions.
	def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

	# Returns true if the given token matches the digest.
  def authenticated?(remember_token)
		return false if remember_digest.nil?
	  BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

	# Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

end
