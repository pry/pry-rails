# encoding: UTF-8

class PryRails::Clear < Pry::ClassCommand
  match "clear"
  group "Rails"
  description "Clear screen"

  def process
    system("clear")
  end
end

PryRails::Commands.add_command PryRails::Clear
