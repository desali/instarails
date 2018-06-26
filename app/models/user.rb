# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_digest :string
#

class User < ApplicationRecord
	attr_accessor :remember_token

	has_secure_password
	has_one_attached :avatar
	has_many :posts
	has_many :likes

	has_many :relationships, foreign_key: :followed_id, dependent: :destroy
	has_many :followers, through: :relationships

	has_many :reverse_relationships, foreign_key: :follower_id,
				class_name: "Relationship", dependent: :destroy
	has_many :following, through: :reverse_relationships,
				source: :followed

	validates_presence_of :email, :username, :avatar
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
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

	# Returns a random token.
	def new_token
    SecureRandom.urlsafe_base64
  end
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


	def follow(user)
		reverse_relationships.create(followed_id: user.id) unless following?(user)
	end

	def unfollow(user)
		reverse_relationships.where(followed_id: user.id).first.destroy if following?(user)
	end

	def following?(user)
		reverse_relationships.where(followed_id: user.id).count > 0
	end

	def feed
		Post.where(user_id: following_ids.append(self.id))
	end

end
