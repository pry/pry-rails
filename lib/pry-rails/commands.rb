# frozen_string_literal: true

PryRails::Commands = Pry::CommandSet.new

command_glob = File.expand_path('commands/*.rb', __dir__)

Dir[command_glob].sort.each do |command|
  require command
end

Pry.commands.import PryRails::Commands
