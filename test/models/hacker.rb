class Hacker < ActiveRecord::Base
  has_many :pokemons
  has_many :beers
end
