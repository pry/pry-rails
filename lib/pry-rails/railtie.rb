# encoding: UTF-8

module PryRails
  class Railtie < Rails::Railtie
    console do
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
  
  Commands = Pry::CommandSet.new do
    create_command "show-routes", "Print out all defined routes in match order, with names." do
      def options(opt)
        opt.banner unindent <<-USAGE
          Usage: show-routes [-G]

          show-routes displays the current Rails app's routes.
        USAGE

        opt.on :G, "grep", "Filter output by regular expression", :argument => true
      end

      def process
        all_routes = Rails.application.routes.routes
        require 'rails/application/route_inspector'
        inspector = Rails::Application::RouteInspector.new
        output.puts inspector.format(all_routes).grep(Regexp.new(opts[:G] || ".")).join "\n"
      end
    end
  end
end

Pry.commands.import PryRails::Commands
