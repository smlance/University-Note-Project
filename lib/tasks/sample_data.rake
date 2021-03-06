namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
    		 email: "example@railstutorial.org",
		 password: "foobarss",
		 password_confirmation: "foobarss",
		 admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "passwordss"
      User.create!(name: name,
                   email: email,
		   password: password,
		   password_confirmation: password);
    end
  end
end