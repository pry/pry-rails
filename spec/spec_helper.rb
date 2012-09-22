require 'minitest/spec'
require 'minitest/autorun'

require 'rr'

class MiniTest::Spec
  include RR::Adapters::RRMethods
end

require 'config/environment'

require 'rails/commands/console'
