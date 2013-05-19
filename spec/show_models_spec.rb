# encoding: UTF-8

require 'spec_helper'

describe "show-models" do
  it "should print a list of models" do
    output = mock_pry('Pry.color = false;', 'show-models', 'exit-all')

    ar_models = <<MODELS
Beer
  id: integer
  name: string
  type: string
  rating: integer
  ibu: integer
  abv: integer
  belongs_to :hacker
Hacker
  id: integer
  social_ability: integer
  has_many :beers
  has_many :pokemons
Pokemon
  id: integer
  name: string
  caught: binary
  species: string
  abilities: string
  belongs_to :hacker
  has_many :beers (through :hacker)
MODELS

    mongoid_models = <<MODELS
Artist
  _id: Moped::BSON::ObjectId
  name: String
  embeds_one :beer (validate)
  embeds_many :instruments (validate)
Instrument
  _id: Moped::BSON::ObjectId
  name: String
  embedded_in :artist
MODELS

    if defined?(Mongoid)
      output.gsub! /^ *_type: String\n/, '' # mongoid 3.0 and 3.1 differ on this
      output.must_equal [ar_models, mongoid_models].join
    else
      output.must_equal ar_models
    end
  end

  it "should highlight the given phrase with --grep" do
    begin
      Pry.color = true

      output = mock_pry('show-models --grep rating', 'exit-all')

      output.must_include "Beer"
      output.must_include "\e[7mrating\e[27m"
      output.wont_include "Pokemon"

      if defined?(Mongoid)
        output.wont_include "Artist"
      end
    ensure
      Pry.color = false
    end
  end

  if defined?(Mongoid)
    it "should also filter for mongoid" do
      output = mock_pry('show-models --grep beer', 'exit-all')
      output.must_include 'Artist'
    end
  end
end
