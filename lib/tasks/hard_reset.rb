namespace :db do
  desc "Reset the db"
  task :hard_reset => :environment do
    File.delete("db/schema.rb")
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
    Rake::Task["db:seed"].execute
    if !Rails.env.test?
      Rake::Task["db:populate"].execute
    end
  end

  # See sample_data.rake for the db:populate task definition
end
