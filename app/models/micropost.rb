class Micropost < ActiveRecord::Base
	attr_accessible :content, :recipients

	USERNAME_REGEX = /@\w+/i

	belongs_to :user

	has_many :recipients, dependent: :destroy
	has_many :replied_users, through: :recipients, source: "user"

	validates :user_id, presence: true
	validates :user_id, presence: true

	default_scope order: 'microposts.created_at DESC'

	scope :from_users_followed_by, lambda { |user| followed_by(user) }

	after_save :save_recipients

	private

		def self.followed_by(user)
      followed_user_ids = %(SELECT followed_id FROM relationships
                            WHERE follower_id = :user_id)
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            { user_id: user })
    end

		def save_recipients
			return unless reply?

			people_replied.each do |user|
				Recipient.create!(micropost_id: self.id, user_id: user.id)
			end
		end

		def reply?
			self.content.match( USERNAME_REGEX )
		end

		def people_replied
			users = []
			self.content.clone.gsub!( USERNAME_REGEX ).each do |username|
				user = User.find_by_username(username[1..-1])
				users << user if user
			end
			users
		end
end
# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

