namespace :db do
  desc "Reset the database; to be used for development and not production"
  task devreset: :environment do

      Rake::Task["db:drop"].execute
      Rake::Task["db:create"].execute
      Rake::Task["db:migrate"].execute



    if !Rails.env.test?
      Rake::Task["db:populate"].execute
    end
  end

  # See sample_data.rake for the db:populate task definition
end

# NOTE: what we really want to do is run the following in a chain:
# `rake db:drop db:create db:migrate`
# or `rake db:schema:load`?
# We also need to run `rake db:test:prepare` to get the test env
# migrations to run...