require "pry-rails/version"

module PryRails
  if defined? Rails && Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 1
    class Railtie < ::Rails::Railtie
      silence_warnings do
        begin
          require 'pry'
          ::IRB = Pry
        rescue LoadError
        end
      end
    end
  end
end

