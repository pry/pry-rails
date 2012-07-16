require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"
require "appraisal"

desc 'Create test Rails app'
task :init_test_app do
  `rm -rf test/app >/dev/null 2>&1`
  `env BUNDLE_GEMFILE=gemfiles/rails30.gemfile bundle exec rails new test/app`
  FileUtils.cp("test/routes.rb", "test/app/config/routes.rb")
  File.open("test/app/Gemfile", 'a+') { |f| f.write(%Q{gem "pry-rails", :path => "../../"}) }
end

desc 'Start the Rails server'
task :server do
  exec 'cd test/app && rails server'
end

desc 'Start the Rails console'
task :console do
  exec 'cd test/app && rails console'
end
