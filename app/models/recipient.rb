class Recipient < ActiveRecord::Base

	belongs_to :micropost
	belongs_to :user
end
# == Schema Information
#
# Table name: recipients
#
#  id           :integer         not null, primary key
#  micropost_id :integer
#  user_id      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

