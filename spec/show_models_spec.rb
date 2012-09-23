# encoding: UTF-8

require 'spec_helper'

describe "show-models" do
  it "should print a list of ActiveRecord models" do
    mock_pry('show-models', 'exit-all').must_equal <<OUTPUT
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
OUTPUT
  end

  it "should highlight the given phrase with --grep" do
    output = mock_pry('show-models --grep beer', 'exit-all')

    output.must_include "\e[0;31mBeer\e[0m"
    output.must_include "has_many \e[0;31mbeer\e[0ms through hacker"
  end
end
