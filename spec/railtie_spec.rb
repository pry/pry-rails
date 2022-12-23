# frozen_string_literal: true

require 'spec_helper'

if (Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR >= 1) ||
   Rails::VERSION::MAJOR >= 6
  require 'rails/command'
  require 'rails/commands/console/console_command'
else
  require 'rails/commands/console'
end

describe PryRails::Railtie do
  it 'should start Pry instead of IRB and make the helpers available' do
    mock = Minitest::Mock.new
    mock.expect :start, true

    Pry.stub :start, mock do
      Rails::Console.start(Rails.application)
      silence_warnings do
        assert_send([Pry, :start])
      end
    end

    %w[app helper reload!].each do |helper|
      _(TOPLEVEL_BINDING.eval("respond_to?(:#{helper}, true)")) # respond_to?(:app), true
        .must_equal true
    end
  end
end
