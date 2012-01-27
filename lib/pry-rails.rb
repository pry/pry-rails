require "pry-rails/version"

module PryRails
  if(defined?(::Rails) and ::Rails::VERSION::MAJOR >= 3)
    class Railtie < ::Rails::Railtie
      silence_warnings do
        begin
          require 'pry'
          ::IRB = Pry
          unless defined?(IRB::ExtendCommandBundle)
            IRB::ExtendCommandBundle = Module.new
          end
					if ::Rails::VERSION::MINOR >= 2
						require "rails/console/app"
						require "rails/console/helpers"
						Object.send(:include, Rails::ConsoleMethods) 
					end
        rescue LoadError
        end
      end
    end
  end
end

