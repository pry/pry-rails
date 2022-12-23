# frozen_string_literal: true

module PryRails
  class Railtie < Rails::Railtie
    console do
      require 'pry'
      require 'pry-rails/commands'

      if Rails::VERSION::MAJOR == 3
        Rails::Console::IRB = Pry

        Pry::ExtendCommandBundle = Module.new unless defined? Pry::ExtendCommandBundle
      end

      Rails.application.config.console = Pry if Rails::VERSION::MAJOR >= 4

      if (Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 2) || Rails::VERSION::MAJOR >= 4
        require 'rails/console/app'
        require 'rails/console/helpers'
        TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
      end
    end
  end
end
