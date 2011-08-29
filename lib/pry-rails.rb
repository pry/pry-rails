require "pry-rails/version"

module PryRails
  if(defined?(::Rails) and ::Rails.version >= "3")
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

