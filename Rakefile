require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"
require "appraisal"

desc 'Create test Rails app'
task :init_test_app do
  `rm -rf test/app >/dev/null 2>&1`
  `env BUNDLE_GEMFILE=gemfiles/rails30.gemfile bundle exec rails new test/app`
  FileUtils.cp("test/routes.rb", "test/app/config/routes.rb")
  FileUtils.cp_r("test/models/", "test/app/app/models/")
  File.open("test/app/Gemfile", 'a+') { |f| f.write(%Q{gem "pry-rails", :path => "../../"}) }
  FileUtils.cd("test/app")
  `env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle install`
  `env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rails g model Pokemon name:string caught:binary species:string abilities:string`
  `env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rails g model Hacker social_ability:integer`
  `env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rails g model Beer name:string type:string rating:integer ibu:integer abv:integer`
  `env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rake db:migrate`
end

desc 'Start the Rails server'
task :server do
  exec 'cd test/app && rails server'
end

desc 'Start the Rails console'
task :console do
  exec 'cd test/app && rails console'
end
