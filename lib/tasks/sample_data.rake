namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(name: "Samuel Hubbard",
								 email: "hsamuel82@gmail.com",
								 password: "freeride",
								 password_confirmation: "freeride")
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@example.com"
			password = "password"
			User.create!(name: name,
									 email: email,
									 password: password,
									 password_confirmation: password)
			end
			users = User.all(limit: 6)
			50.times do
				content = Faker::Lorem.sentence(5)
				users.each { |user| user.microposts.create!(content: content) }
			end
		end
	end