# encoding: UTF-8

module PryRails
  class Railtie < Rails::Railtie
    console do
      if !ENV["DISABLE_PRY_RAILS"]
        require 'pry'
        require 'pry-rails/commands'

        if Rails::VERSION::MAJOR == 3
          Rails::Console::IRB = Pry

          unless defined? Pry::ExtendCommandBundle
            Pry::ExtendCommandBundle = Module.new
          end
        end

        if Rails::VERSION::MAJOR == 4
          Rails.application.config.console = Pry
        end

        if (Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 2) ||
            Rails::VERSION::MAJOR == 4
          require "rails/console/app"
          require "rails/console/helpers"
          TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
        end
      end
    end
  end
end
