# encoding: UTF-8

if defined?(Rails) && !ENV['DISABLE_PRY_RAILS']
  require 'pry-rails/railtie'
end
