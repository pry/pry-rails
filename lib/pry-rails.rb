require "pry-rails/version"

module PryRails
  class Railtie < ::Rails::Railtie
    if(defined? Rails)
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

