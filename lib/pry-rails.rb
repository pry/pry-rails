require "pry-rails/version"

module PryRails
  begin
    require 'pry'

    if (defined?(::Rails::Console) and ::Rails::VERSION::MAJOR >= 3)
      class Railtie < ::Rails::Railtie
        silence_warnings do
          ::Rails::Console::IRB = Pry

          unless defined?(Pry::ExtendCommandBundle)
            Pry::ExtendCommandBundle = Module.new
          end

          if ::Rails::VERSION::MINOR >= 2
            require "rails/console/app"
            require "rails/console/helpers"
            TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
          end
        end
      end
    end
  rescue LoadError
  end
end
