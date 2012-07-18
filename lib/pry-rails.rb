# encoding: UTF-8

require 'pry'
require 'pry-rails/version'

if defined?(Rails)
  require 'pry-rails/railtie'
  require "pry-rails/commands"

  Pry.commands.import PryRails::Commands
end
