# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  location        :string(255)
#  birthday        :string(255)
#  about           :string(255)
#  hobbies         :string(255)
#  image           :string(255)
#  username        :string(255)
#

class User < ActiveRecord::Base
	attr_accessible :name, 
									:email, 
									:password, 
									:password_confirmation, 
									:location, 
									:birthday, 
									:about, 
									:hobbies,
									:image,
									:username
	has_secure_password
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
																	 class_name: "Relationship",
																	 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	mount_uploader :image, ImageUploader
	before_save :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
										format: { with: valid_email_regex },
										uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }
	valid_birthday_regex = /^(0[1-9]|1[012])[\/](0[1-9]|[12][0-9]|3[01])[\/][0-9]{4}$/
	validates :birthday, format: { with: valid_birthday_regex }
	valid_username_regex = /^[a-z]\w*[a-z0-9]$/i
	validates :username, presence: true,
											 format: { with: valid_username_regex },
											 uniqueness: { case_sensitive: false },
											 length: { minimum: 4 }

	default_scope order: 'users.name'

	def feed
		Micropost.from_users_followed_by(self)
	end

	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy
	end

	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
