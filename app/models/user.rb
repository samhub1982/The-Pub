# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
	attr_accessible :name, 
									:email, 
									:password, 
									:password_confirmation, 
									:avatar, 
									:location, 
									:birthday, 
									:about, 
									:hobbies
	has_secure_password
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
																	 class_name: "Relationship",
																	 dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	has_attached_file :avatar, styles: { small: "150x150>", 
																			 medium: "150x150>", 
																			 large: "500x500>", 
																			 thumb: "75x75#" },
																			 processors: [:cropper]
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :reprocess_avatar, :if => :cropping?
	before_save :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
										format: { with: valid_email_regex },
										uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

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

	def cropping?
		!crop_x.blank? && !crop_y.blank? && crop_w.blank? && !crop_h.blank?
	end

	def avatar_geometry(style = :original)
		@geometry ||= {}
		@geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
	end

	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end

		def reprocess_avatar
			avatar.reprocess!
		end
end
