require "pry-rails/version"

module PryRails
  if(defined?(::Rails) and ::Rails::VERSION::MAJOR >= 3)
    class Railtie < ::Rails::Railtie
      silence_warnings do
        begin
          require 'pry'
          ::IRB = Pry
          IRB::ExtendCommandBundle = Pry
        rescue LoadError
        end
      end
    end
  end
end

