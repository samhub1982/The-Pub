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
	attr_accessible :name, :email, :password, :password_confirmation, :avatar, :location, :birthday, :about, :hobbies
	has_secure_password
	has_many :microposts, dependent: :destroy
	has_attached_file :avatar, styles: { small: "150x150>", medium: "150x150>", large: "500x500>", thumb: "75x75#" }
	before_save :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
										format: { with: valid_email_regex },
										uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	def feed
		# This is preliminary. Will implement after relationship model
		Micropost.where("user_id = ?", id)
	end

	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
