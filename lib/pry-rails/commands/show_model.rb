# frozen_string_literal: true

class PryRails::ShowModel < Pry::ClassCommand
  match 'show-model'
  group 'Rails'
  description 'Show the given model.'

  def options(opt)
    opt.banner unindent <<-USAGE
      Usage: show-model <model name>

      show-model displays one model from the current Rails app.
    USAGE
  end

  def process
    Rails.application.eager_load!

    if args.empty?
      output.puts opts
      return
    end

    begin
      model = Object.const_get(args.first)
    rescue NameError
      output.puts "Couldn't find model #{args.first}!"
      return
    end

    formatter = PryRails::ModelFormatter.new

    # fixed to use both AR & MongoId
    result = []
    if defined?(ActiveRecord::Base) && model < ActiveRecord::Base
      models = true
      result << formatter.format_active_record(model)
    end

    if defined?(Mongoid::Document) && model < Mongoid::Document
      models = true
      result << formatter.format_mongoid(model)
    end

    result = ["Don't know how to show #{model}!"] unless models
    output.puts result.join
  end
end

PryRails::Commands.add_command PryRails::ShowModel
