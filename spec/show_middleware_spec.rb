# frozen_string_literal: true

require 'spec_helper'

describe 'show-middleware' do
  it 'should print a list of middleware' do
    output = mock_pry('show-middleware', 'exit-all')

    _(output).must_match(/^use ActionDispatch::Static$/)
    _(output).must_match(/^use ActionDispatch::ShowExceptions$/)
    _(output).must_match(/^run TestApp.routes\Z/)
  end
end
