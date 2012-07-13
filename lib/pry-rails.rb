# encoding: UTF-8

require 'pry'

require 'pry-rails/version'
require 'pry-rails/railtie'
require "pry-rails/commands"

Pry.commands.import PryRails::Commands

