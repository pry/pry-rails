class Pokemon < ActiveRecord::Base
  belongs_to :hacker
  has_many :beers, through: :hacker
end
