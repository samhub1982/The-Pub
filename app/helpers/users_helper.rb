module UsersHelper

	def image_for(user)
		image_id = user.avatar.url(:thumb)
		image_tag(image_id, alt: user.name)
	end
end
