require "pry-rails/version"

module PryRails
  if(defined?(::Rails) and ::Rails::VERSION::MAJOR >= 3)
    class Railtie < ::Rails::Railtie
      silence_warnings do
        begin
          require 'pry'
          Rails::Console::IRB = Pry
          unless defined?(Pry::ExtendCommandBundle)
            Pry::ExtendCommandBundle = Module.new
          end
          if ::Rails::VERSION::MINOR >= 2
            require "rails/console/app"
            require "rails/console/helpers"
            TOPLEVEL_BINDING.eval('self').extend Rails::ConsoleMethods
          end
        rescue LoadError
        end
      end
    end
  end
end
