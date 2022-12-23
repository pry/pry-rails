# frozen_string_literal: true

require 'spec_helper'

describe 'show-notes' do
  it 'prints all notes' do
    output = mock_pry('show-notes', 'exit-all')

    # FIXME: does not work
    _expected = <<NOTES
lib/pry-rails/commands/notes.rb:
  * [ 8] [FIXME] fix me test
  * [15] [TODO] todo me test

\e[0Glib/pry-rails/commands/notes.rb
NOTES

    # TODO: only the last output is expected
    # but I'd like to check all of the outputs
    expected = "\e[0Glib/pry-rails/commands/find_route.rb
lib/pry-rails/commands/notes.rb\n"
    _(output).must_equal expected
  end

  it 'prints filtered notes' do
    output = mock_pry('show-notes -w FIXME', 'exit-all')

    expected = "\e[0Glib/pry-rails/commands/find_route.rb\n"
    _(output).must_equal expected
  end
end
