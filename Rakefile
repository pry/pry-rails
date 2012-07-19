require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"
require "appraisal"

include FileUtils

desc 'Create test Rails app'
task :init_test_app => 'appraisal:install' do
  # Remove and generate test app using Rails 3.0
  rm_rf 'test/app'
  system 'env BUNDLE_GEMFILE=gemfiles/rails30.gemfile bundle exec rails new test/app'

  # Copy test routes file into place
  cp 'test/routes.rb', 'test/app/config/routes.rb'

  # Remove rjs line from environment, since it's gone in versions >= 3.1
  env_contents = File.readlines('test/app/config/environments/development.rb')
  File.open('test/app/config/environments/development.rb', 'w') do |f|
    f.puts env_contents.reject { |l| l =~ /rjs/ }.join("\n")
  end

  # Generate a few models
  cd 'test/app'
  system 'env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rails g model Pokemon name:string caught:binary species:string abilities:string'
  system 'env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rails g model Hacker social_ability:integer'
  system 'env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rails g model Beer name:string type:string rating:integer ibu:integer abv:integer'
  system 'env BUNDLE_GEMFILE=../../gemfiles/rails30.gemfile bundle exec rake db:migrate'

  # Replace generated models
  cd '../..'
  cp_r 'test/models', 'test/app/app/models'
end

desc 'Start the Rails server'
task :server do
  exec 'cd test/app && rails server'
end

desc 'Start the Rails console'
task :console do
  exec 'cd test/app && rails console'
end
