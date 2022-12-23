# frozen_string_literal: true

require 'spec_helper'

describe 'show-model' do
  it 'should print one ActiveRecord model' do
    output = mock_pry('show-model Beer', 'exit-all')

    expected = <<MODEL
\e[0GBeer
  id: integer
  name: string
  type: string
  rating: integer
  ibu: integer
  abv: integer
  belongs_to :hacker
MODEL

    _(output).must_equal expected
  end

  if defined? Mongoid
    it 'should print one Mongoid model' do
      output = mock_pry('show-model Artist', 'exit-all')

      expected = <<MODEL
\e[0GArtist
  _id: BSON::ObjectId
  name: String
  embeds_one :beer (validate)
  embeds_many :instruments (validate)
MODEL

      output.gsub!(/^ *_type: String\n/, '') # mongoid 3.0 and 3.1 differ on this
      output.gsub!(/Moped::BSON/, 'BSON')    # mongoid 3 and 4 differ on this
      _(output).must_equal expected
    end
  end

  it "should print an error if the model doesn't exist" do
    output = mock_pry('show-model FloojBulb', 'exit-all')
    _(output).must_match(/Couldn't find model FloojBulb!/)
  end

  it "should print an error if it doesn't know what to do with the model" do
    output = mock_pry('show-model PryRails', 'exit-all')
    _(output).must_match(/Don't know how to show PryRails!/)
  end

  it 'should print help if no model name is given' do
    output = mock_pry('show-model', 'exit-all')
    _(output).must_match(/Usage: show-model/)
  end
end
