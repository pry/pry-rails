# encoding: UTF-8

require 'spec_helper'

describe "show-models" do
  it "should print a list of models" do
    output = mock_pry('show-models', 'exit-all')

    ar_models = <<MODELS
Beer
  id: integer
  name: string
  type: string
  rating: integer
  ibu: integer
  abv: integer
  belongs_to hacker
Hacker
  id: integer
  social_ability: integer
  has_many pokemons
  has_many beers
Pokemon
  id: integer
  name: string
  caught: binary
  species: string
  abilities: string
  belongs_to hacker
  has_many beers through hacker
MODELS

    mongoid_models = <<MODELS
Artist
  _id: Moped::BSON::ObjectId
  _type: String
  name: String
  embeds_one beer, validate
  embeds_many instruments, validate
Instrument
  _id: Moped::BSON::ObjectId
  _type: String
  name: String
  embedded_in artist
MODELS

    if defined?(Mongoid)
      output.must_equal [ar_models, mongoid_models].join
    else
      output.must_equal ar_models
    end
  end

  it "should highlight the given phrase with --grep" do
    output = mock_pry('show-models --grep beer', 'exit-all')

    output.must_include "\e[0;31mBeer\e[0m"
    output.must_include "has_many \e[0;31mbeer\e[0ms through hacker"

    if defined?(Mongoid)
      output.must_include "embeds_one \e[0;31mbeer\e[0m"
    end
  end
end
