# encoding: UTF-8

require 'pry'
require 'pry-rails/version'

if defined?(Rails)
  require 'pry-rails/railtie'
  require 'pry-rails/commands'

  command_glob = File.expand_path('../pry-rails/commands/*.rb', __FILE__)

  Dir[command_glob].each do |command|
    require command
  end

  Pry.commands.import PryRails::Commands
end
